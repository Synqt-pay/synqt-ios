# SYNQT iOS SDK

Take payments (SYNQT payins) in an iOS app. The SDK can show a Synqt-branded payment sheet that asks the payer for exactly the details their payment method needs, send the payment, and tell you what to do next. You don't build or maintain any payment forms.

It covers SYNQT API version 2 (spec 2.84): the direct API for all payment methods except CARD, and the hosted Payment Web App. CARD comes from a separate card add-on, available on request from SYNQT to PCI DSS compliant merchants. It is the iOS counterpart of the [SYNQT Android SDK](https://github.com/synqt-pay/synqt-android): the same API, the same payment sheet, the same field rules and the same wording.

## Requirements

- iOS 15 or later. The package also builds for macOS 12 so its tests run on a Mac; the sheet is presented on iOS only.
- Swift 5.9 or later (Xcode 15+). Every network call is `async`.
- A backend of your own that mints a SYNQT token for each order. The app never holds the merchant's private key or secret key.

No third-party dependencies.

## Install

The SDK is a Swift package, installed from GitHub by version tag.

- **Xcode:** **File > Add Package Dependencies**, enter `https://github.com/synqt-pay/synqt-ios.git`, choose **Up to Next Minor Version** from `0.1.0`, and add the `SynqtSDK` library to your app target.
- **Package.swift:**

  ```swift
  dependencies: [.package(url: "https://github.com/synqt-pay/synqt-ios.git", .upToNextMinor(from: "0.1.0"))],
  targets: [.target(name: "App", dependencies: [.product(name: "SynqtSDK", package: "synqt-ios")])]
  ```

Versions follow semantic versioning. Below 1.0, a minor release (0.2.0) may break the API, so **Up to Next Minor Version** takes only fixes; move to a new minor version on purpose. The card add-on, available to PCI DSS compliant merchants on request from SYNQT, needs the same release of this SDK.

## Integrating the SDK, step by step

Follow these in order. Steps 1 and 2 happen once; steps 3 to 7 happen for every order.

### 1. Add the SDK to your project

Add the package as in [Install](#install). The module is `SynqtSDK` and its entry point the `Synqt` type, so an app with its own `Money` or `PaymentMethod` can still write `SynqtSDK.Money`. The SDK brings its own fonts, strings and privacy manifest, so you add nothing to your Info.plist. Build once to check it compiles.

Apps that ship the SDK must include the Phosphor Icons MIT notice and the Instrument Sans OFL notice in `THIRD_PARTY_NOTICES.md`, for example on an acknowledgements screen.

### 2. Add a token endpoint to your backend

SYNQT calls need a short-lived token, and minting one needs the merchant's private key, so this runs on your server only. For each order, your backend:

1. Creates a payin ID that is new for this attempt, such as `order-1042-1` (letters, digits, `_` and `-`, at most 250 characters).
2. Calls `POST /auth-tokens-by-action` with header `X-API-Version: 2` and this body, signed with SHA256withRSA over the exact bytes sent, base64-encoded in an `X-SIGNATURE` header:

   ```json
   {"merchantCode":"MID","validitySecs":1800,"action":"PAYIN_CREATE","idPayment":"order-1042-1",
    "money":{"amount":1250.00,"currencyCode":"ZAR"},"timestamp":1793625059}
   ```

3. Returns the `token` from the response, the payin ID and the amount to the app.

`PAYIN_CREATE` covers everything the sheet and the Payment Web App need. To show the merchant's name in the sheet's summary, use `POST /auth-tokens` instead, with the same signature and an `operations` list: `POST /payins/!availablePaymentOptions`, `POST /payins/order-1042-1`, `GET /payins/order-1042-1` and `GET /merchant-info`. The synqt-examples repo's `scripts/sandbox-token.sh` is a working example of the signing, in shell.

The `money` in the token locks it to that amount, so the app can't change it. Never return a token with wildcard operations to an app.

### 3. Create the payin in the app

When the payer taps your checkout button, fetch a token from your backend, then:

```swift
import SynqtSDK

let payin = try Synqt(.sandbox).payin(
    token: response.token,
    payinID: response.payinID,
    money: Money(amount: Decimal(string: "1250.00")!, currencyCode: "ZAR"), // the same amount and currency as the token
    returnURL: "https://shop.example.com/payment/return", // https, see "Other ways to pay"
    callbackURL: "https://shop.example.com/synqt/callback" // your backend, step 7
)
```

This makes no network call. It throws `SynqtArgumentError` if the payin ID is malformed. Use `.sandbox` while testing and `.live` for real payments.

### 4. Choose the payment method

Ask SYNQT what this merchant can take for this amount, and keep the ones the sheet supports:

```swift
let offered = try await payin.availablePaymentOptions()
let supported = Set(Synqt.directPaymentMethods.map(\.code))
let choices = offered.filter { supported.contains($0.code) }
```

Show `choices` in your own checkout, using `option.name` as the payer-facing name, and let the payer pick one. If your checkout only offers one method, you can skip this step and pass its code, such as `"CAPITEC_PAY"`, in step 5.

### 5. Show the payment sheet

Present it from the view controller on screen. In SwiftUI, that is the window's top view controller (the demo's `topViewController()` finds it). Run it in a `Task` that lives as long as your checkout screen, since cancelling the task closes the sheet:

```swift
Task {
    let result = try await payin.presentPaymentSheet(
        from: viewController,
        paymentMethodCode: methodCode,
        prefill: [
            "emailAddress": email,
            "customerName.firstName": firstName,
            "customerName.lastName": lastName,
        ],
        onPresented: { /* the sheet is on screen */ },
        onPaymentStarted: { /* details sent to SYNQT: start showing progress, step 6 */ }
    )
    switch result {
    case nil: break                       // the payer closed the sheet without paying
    case .instructions?: break            // the sheet already showed the next step; go to step 6
    case let .redirect(httpMethod, url, formData)?: break // open url, see below
    }
}
```

Pass in `prefill` whatever your app already knows about the payer. The sheet hides those fields, and pays straight away when nothing mandatory is left to ask. See [The payment sheet](#the-payment-sheet) for what it shows.

A `.redirect` means the payer finishes on a bank's page. For `httpMethod` GET, open `url` in a `WKWebView` or Safari. For POST, submit `formData` to it as an HTML form, for example by loading a self-submitting form into a `WKWebView` with `loadHTMLString`. The demo's `PaymentWebView` handles GET.

To skip the sheet and use SYNQT's hosted Payment Web App instead, call `presentPaymentApp` here; see [Other ways to pay](#other-ways-to-pay).

### 6. Show the payer where the payment stands

Once `onPaymentStarted` has run (or the Payment Web App has opened), poll `payin.status()` every few seconds until it is final:

```swift
let s = try await payin.status()
switch s.status {
case .success: break // show "Paid", but fulfil only from step 7
case .failed, .refused: showError(s.failureReason?.payerMessage)
default: break       // .processing or .unknown: keep polling
}
```

Stop polling when the payer leaves the screen or `s.status.isFinal` is true. Before the payment is created, `status()` throws `SynqtAPIError` with HTTP 410.

### 7. Confirm the payment on your backend

SYNQT posts `{"idEntity":"order-1042-1"}` to your `callbackURL` on every status change. Reply 200 at once, then call `GET /payins/order-1042-1` from your backend and fulfil the order only when `process.status` is `SUCCESS` and the amount matches. The callback carries no status and no signature, and the app's view of the status is not proof of payment.

### 8. Go live

Switch to `.live` and your live merchant credentials, test one real payment per method you offer, and work through [Security and compliance](#security-and-compliance).

## The payment sheet

`presentPaymentSheet` shows a form sheet (a bottom sheet on iPhone, a centred card on iPad) with:

- the Synqt wordmark, an order summary (amount due, payment method, reference, and the merchant name if the token allows `GET /merchant-info`)
- one plain-language field per detail the method needs, grouped into sections, with optional fields marked. A section with any mandatory field in it is mandatory as a whole, which is stricter than SYNQT's spec
- the right keyboard for each field, and checks on length and format before anything is sent
- a menu of the banks or providers SYNQT returns for this payin and payment method (`POST /payins/!availablePaymentOptions`), instead of raw operator codes. An optional bank field is hidden when SYNQT lists none, as on Capitec Pay, Absa Pay, FNB Pay and Nedbank Pay, which accept no bank code. If the list can't be loaded (the connection fails or SYNQT has a server error, tried three times, 2 seconds apart), a mandatory bank or provider field says so and offers "Try again"
- a Pay button with the amount, and a processing state with the Synqt Orbit loader while the request runs. It is drawn natively from the designer's Lottie file, so the SDK needs no animation library; it follows light and dark mode and holds still with Reduce Motion on. The sheet closes only from its close button, never by tapping outside it or swiping it down, and the button is covered while a payment is being sent

Fields the app prefills (through `prefill`) are hidden when their value passes its checks, and a section goes when all of its fields are filled in; once the first and last name are filled in, the optional title, middle name and suffix go too. When every mandatory field of a method is filled in this way, the sheet skips the form and pays straight away, showing only the processing screen. If SYNQT refuses a value, the form appears with the error so the payer can correct it. Methods with only optional fields always show their form.

When SYNQT accepts a payment the payer finishes in another app (Zapper, SnapScan, UPI and others), the sheet stays open and shows the next step: an "Open Zapper" button, the QR code for scanning from another phone, the amount (or the exact amount SYNQT requires), the reference, and a live "Time left to pay" countdown. The method's app opens by itself once if it is installed: the link is opened as a universal link only, then on the app's own URL scheme where one is known (SnapScan), so nothing needs adding to your Info.plist. If the app isn't installed, the button opens the link in Safari. For Pay offline the next step is "How to pay": the one-time reference in its own card at the top ("Your payment will fail without this reference."), then the bank account to transfer to (account holder, account number, bank and any account type SYNQT sends, then the branch, or the bank code when there is no branch) and the amount, with copy buttons on the values a payer types into their banking app (the amount is copied as a bare number), then a four-point "Before you pay" notice based on the Payment Web App's (`nextStep.payInto`). The notice covers exact amounts, one-time references, transfer fees and banking hours, and third-party payments. Done, or closing the sheet, returns the result. Apps with their own screens get the same details from `CreatePayinResult.instructions`' `nextStep`.

If SYNQT refuses the payment, the reason appears in the sheet under the field it is about, so the payer can fix it and try again. VoiceOver reads every error out as it appears, and at the largest accessibility text sizes the summary and account details stack each label above its value. The sheet follows the phone's light or dark setting, also when it changes while the sheet is open, even when the app forces one of its own; and text grows with Dynamic Type. On iOS 15 and 16 a change made while the sheet is open shows once the app is active again (after Control Center or Settings), so an automatic switch at sunset waits until then.

`prefill` takes field paths such as `emailAddress`, `phoneNumber` or `customerName.lastName`. Pre-filled fields stay editable.

What the app hears from the sheet, in order:

1. `onPresented` runs once the sheet is on screen. Before that the SDK fetches the bank list and merchant name, so there is a short gap after the call.
2. `onPaymentStarted` runs each time the payer's details pass the sheet's checks and go to SYNQT, whether the payer tapped Pay or the sheet paid straight away. From here `payin.status()` has something to report; until then SYNQT answers HTTP 410 for the payin ID. If SYNQT refuses the details there may still be no payin, and a corrected retry runs it again.
3. The call returns once the sheet has closed: nil if the payer closed it without paying, otherwise the result.

Cancelling the task that called `presentPaymentSheet` closes the sheet and returns nil, even if SYNQT already accepted the payment, so check `payin.status()` after a cancel.

## Other ways to pay

**Build the payment method yourself.** Every method is a case of `PaymentMethod` with its own struct, and its required fields must be set or the code won't compile. Types that every method uses, such as `PaymentMethod.Account` and `PaymentMethod.PersonName`, are one type shared by all methods, so `create` checks the parts the method needs before sending and throws `SynqtArgumentError` naming the missing or unexpected field:

```swift
let result = try await payin.create(.capitecPay(.init(
    phoneNumber: "0821234567",
    customerName: .init(lastName: "Doe")
)))
```

Retrying `create` after a network failure is safe: if SYNQT already has the payin, the SDK fetches it instead of creating another.

**Use SYNQT's hosted Payment Web App** when you don't want any payment UI in the app:

```swift
let result = await payin.presentPaymentApp(from: viewController, merchantCode: "MID",
                                           paymentMethodCode: "CAPITEC_PAY",          // optional: open on this method
                                           prefill: ["phoneNumber": "+27821234567"], // optional: the payer can still edit it
                                           onPresented: { /* the Payment Web App is on screen */ })
switch result {
case .returned(let url): break // the Payment Web App sent the payer to returnURL; url carries what it added
case .closed: break            // the payer closed it first
}
let status = try await payin.status() // either way, ask where the payment stands
```

`presentPaymentApp` shows the Payment Web App full screen in the app, with a Close button, and returns when the payer reaches `returnURL` (same host and path, any query) or taps Close. Links to bank and payment apps open outside it. To use Safari instead, `openPaymentApp(merchantCode:)` returns once Safari has the page; the payer then comes back through `returnURL`, which must be a universal link your app handles. The `returnURL` must be https either way.

`paymentMethodCode` opens the Payment Web App on that method (use one `availablePaymentOptions` returns), and the payer can still pick another. `prefill` uses the Payment Web App's parameter names, not the sheet's field paths: `phoneNumber`, `emailAddress`, `accountName`, `accountNumber`, `upiId`, `idCustomer`, `governmentId`, `passportNumber`, `postalCode`, `city`, `district`. The payer can still change prefilled details. The SDK does not check these values; a wrong code or value shows up in the Payment Web App. To lock the method or the details instead, leave these out and pass the raw parameters in `extra`.

## API reference

Everything a merchant's app uses, in the order an integration uses it. Each call needs a token that allows its SYNQT operation: a `PAYIN_CREATE` token covers creating the payin, its payment options and its status, while `paymentOperators` and the merchant name in the sheet need operations your backend adds when it mints the token.

### 1. Set up

| Type or call | What it does |
|---|---|
| `Synqt(_ environment:, session: = .shared)` | The entry point for one environment. Pass your own `URLSession` to control timeouts or proxies. |
| `Synqt.Environment` | `.sandbox`, `.live` or `.stable` (see the table below). |
| `environment.apiBaseURL`, `environment.paymentAppBaseURL` | The base URLs, for your backend's own calls such as minting tokens. |
| `synqt.payin(token:payinID:money:returnURL:callbackURL:)` | One order's `Payin`. `payinID` is your own order ID (letters, digits, `_` and `-`, at most 250) and must match the token. Throws `SynqtArgumentError` for a malformed ID. |
| `Money(amount:currencyCode:)` | An amount as a `Decimal`, never rounded. Its `description` is the house format, such as `R1,250.00`. |
| `payin.id`, `payin.money` | The order's payin ID and amount. |

| Environment | API | Use |
|---|---|---|
| `.sandbox` | `api.sandbox.synqt.io` | Testing. The amount decides the outcome (see SYNQT's sandbox docs). |
| `.live` | `api.synqt.io` | Real payments. |
| `.stable` | `api.stable.aopay.io` | SYNQT's internal development platform. Not for merchants. |

### 2. Choose a payment method

| Type or call | What it does |
|---|---|
| `payin.availablePaymentOptions(segmentCode: = nil)` | `[PaymentOption]`: the methods SYNQT allows for this merchant and amount. |
| `PaymentOption` | `code`, `operators` (its banks or providers), `segmentCode`, and `name`, the payer-facing name (nil for methods the sheet doesn't support). |
| `Synqt.directPaymentMethods` | `[DirectPaymentMethod]`: the methods the sheet can collect details for, each with `code` and `name`. |
| `synqt.paymentOperators(token:)` | `[PaymentOperator]`: every bank and provider SYNQT knows, each with `code`, `name` and `externalProviders`. |

`paymentOperators` is not tied to a payin, and a `PAYIN_CREATE` token cannot call it. Your backend mints a token with `POST /auth-tokens` and the operation `GET /payment-operators`. It lists the whole system; to see what one merchant can use for a given amount, use `availablePaymentOptions`.

### 3. Take the payment

Pick one of three ways.

| Type or call | What it does |
|---|---|
| `payin.presentPaymentSheet(from:paymentMethodCode:prefill:customerIP:onPresented:onPaymentStarted:)` | The Synqt payment sheet. Returns `CreatePayinResult?` once it has closed: nil when the payer closed it without paying. See [The payment sheet](#the-payment-sheet). |
| `payin.create(_ paymentMethod:, customerIP: = nil)` | Your own UI: send a `PaymentMethod` you built. Returns `CreatePayinResult`. |
| `PaymentMethod` | One case per method (`.capitecPay(...)`, `.zapperQr(...)` and the rest), each with its own struct of fields, following SYNQT's spec. |
| `payin.presentPaymentApp(from:merchantCode:paymentMethodCode:prefill:extra:onPresented:)` | SYNQT's hosted Payment Web App, inside your app. Returns `PaymentAppResult` once it has closed. |
| `PaymentAppResult` | `.returned(URL)`: the payer reached `returnURL`, with whatever the Payment Web App added to it. `.closed`: the payer tapped Close, or the task was cancelled. |
| `payin.openPaymentApp(merchantCode:paymentMethodCode:prefill:extra:)` | The Payment Web App in Safari. Returns once Safari has it; the payer comes back through `returnURL` as a universal link. |
| `payin.paymentAppURL(merchantCode:paymentMethodCode:prefill:extra:)` | The Payment Web App's URL, for a web view of your own. |

`customerIP` is checked against the merchant's IP allow and deny lists, so pass the payer's real IP if you have it. `paymentMethodCode` and `prefill` preselect a method and details the payer can still change; `extra` adds any other Payment Web App parameter as given.

### 4. After the payment is created

| Type or call | What it does |
|---|---|
| `CreatePayinResult.redirect(httpMethod:url:formData:)` | Send the payer to `url`. GET: open it. POST: submit `formData` to it, for example in a `WKWebView`. |
| `CreatePayinResult.instructions(paymentMethod:nextStep:)` | The payer finishes elsewhere. `paymentMethod` is SYNQT's full `PaymentMethodResponse`; `nextStep` gathers what to show. The sheet already shows it. |
| `NextStep` | `appLink` (open on this phone), `qrCodeImageURL` (a temporary image link) or `qrCodeData` (draw your own), `amountToPay` (if set, the payer must pay exactly this), `reference`, `expiresAt` (ISO 8601) and `payInto` (Pay offline: the account to transfer to, with `accountName`, `accountNumber`, `accountType`, `bankName`, `bankCode` and `bankBranch`). |
| `payin.setExternalReference(_:)` | Sends the payer's bank or UTR reference, for methods that need it. |

### 5. Check the outcome

| Type or call | What it does |
|---|---|
| `payin.status()` | `PayinStatus` for this payin, at any time once a payment has been sent. HTTP 410 means SYNQT has no payin with this ID yet. |
| `PayinStatus` | `status`, `requested`, `fee`, `isTest`, `failureReason`, `paymentMethod` (a `PaymentMethodResponse`), `createdAt` and `processedAt`. |
| `PayinStatus.Status` | `.processing`, `.success`, `.failed`, `.refused`, or `.unknown` for a status this SDK version doesn't know (treat it like processing). `isFinal` is true for success, failed and refused. |
| `FailureReason` | `code`, `message` (written for the merchant), `failedAt`, and `payerMessage`, the wording to show the payer. |

The app's view of the status is for display only. SYNQT calls your `callbackURL` on every status change, and only your backend's own `GET /payins/{id}` decides that an order is paid.

### 6. Errors

| Error | When |
|---|---|
| `SynqtAPIError` | SYNQT refused the request. `httpCode` and `errors`, a list of `Reason` with `code`, `field` and `description`. A 406 is a business error such as `INVALID_PHONE_NUMBER`, and `field` names the input it is about. |
| `SynqtArgumentError` | Something the app passed can't be sent: a malformed payin ID, an unknown method code, a method missing a field. `message`, and `path` naming the field. |
| `URLError` | Network failures. |

`SynqtAPIError` never contains the raw response, because SYNQT echoes what the payer typed in it.

A payment method response that doesn't fit its model (a field of an unexpected type) reads as `.unknown(paymentMethodCode:)` rather than failing, so a payin SYNQT has created never surfaces as an error; `nextStep` is read separately and still works.

A payin ID can be used once. Calling `create` again with the same ID is a safe retry and returns the existing payin, but only for the same payment method. If the ID was already used with another method, `create` throws `SynqtAPIError` with HTTP 409 and the code `PAYIN_ALREADY_STARTED`, and the sheet tells the payer to start a new payment. Use a new payin ID and token for each attempt.

### 7. Match your own screens (optional)

The building blocks the sheet uses are public SwiftUI views for apps that want their screens to match. The fonts register themselves; nothing goes in your Info.plist.

| Type | What it is |
|---|---|
| `SynqtCard` | A titled card. |
| `SynqtTextField` | A labelled text field with helper and error text, and a `SynqtKeyboard` (`.text`, `.name`, `.email`, `.phone`, `.number`). |
| `SynqtDropdown` | A labelled menu of `(value, label)` options. |
| `SynqtButtonStyle` | `.primary`, `.accent` or `.outline`. |
| `SynqtErrorBanner` | The sheet's error banner. |
| `SynqtColors` | The brand tokens: `SynqtColors.for(colorScheme)`, `.light` and `.dark`, plus `SynqtColors.magenta` and `.aqua`. |
| `Font.synqt(size, weight)` | Instrument Sans, with `SynqtWeight` `.regular`, `.medium` or `.semibold`. |

## Translations

Every piece of text the SDK shows a payer is a localized string, so the sheet follows the phone's language once translations exist:

- `Sources/SynqtSDK/Resources/en.lproj/Synqt.strings`: the sheet's own text (headings, buttons, next-step and error messages), generated with the forms.
- `Sources/SynqtSDK/Resources/en.lproj/SynqtForm.strings`: method names, field labels, hints, validation messages and tile questions. Its keys are the ones `MethodFormData.swift` uses, so change both together.

The keys are the Android SDK's string resource names, so one translation can serve both platforms. To add a language, copy both files to `<language>.lproj` (for example `af.lproj` or `zu.lproj`) and translate the text, keeping the keys and the `%1$@` placeholders. A string with no translation falls back to English. Two things stay in English whatever the language: SYNQT's own error descriptions and bank or provider names, which come from SYNQT's servers.

## Security and compliance

- Never put the merchant's private key or secret key in an app. Tokens come from your backend, one per order, locked to the amount.
- Only your backend's own status check proves a payment. The return URL, the sheet closing and `payin.status()` do not.
- This SDK has no card code. CARD is offered only with the separate card add-on, for PCI DSS compliant merchants, which draws, checks and encrypts the card fields itself. The add-on uses this SDK's add-on API (Swift SPI `SynqtAddon`), which apps never need.
- The SDK ships an Apple privacy manifest (`Sources/SynqtSDK/Resources/PrivacyInfo.xcprivacy`) declaring the payer details it sends to SYNQT; Xcode adds it to your app's privacy report.
- Payment details include personal information (ID numbers, account numbers, phone numbers, emails) covered by POPIA. Don't log requests, responses or `SynqtAPIError` descriptions alongside customer data.

## Payment method models and the SYNQT API version

The payment method models (`PaymentMethods.swift`), the sheet's fields (`MethodFormData.swift`), all of the sheet's text (`SynqtForm.strings` and `Synqt.strings`), the colours (`UI/SynqtColors.swift`) and the shared field test cases (`FieldCasesTests.swift`) are generated from SYNQT's OpenAPI spec and SYNQT's shared tables. CARD's raw card number fields are left out of this SDK, as they put the app in PCI DSS scope; only the card add-on has them.

They follow SYNQT API 2.84 today, and the spec lives with the generator app. A new SYNQT API version updates these three files in one commit, and every SYNQT SDK moves to the same version together, so they all ask payers for the same things in the same words.

The Android README describes the South African mandatory fields, the "at least one of" tiles and the ID or passport question.

## Project layout

One module, `SynqtSDK`, with its sources grouped by feature under `Sources/SynqtSDK`. Apps only ever `import SynqtSDK`, so the folders don't affect integration.

| Folder | What it holds |
|---|---|
| `Client/` | The entry points apps call (`Synqt`, `Payin`), the Payment Web App presenter, and the parsing of SYNQT's responses. |
| `Models/` | The public types apps read and send: `PaymentMethod` and `PaymentMethodResponse`, the payin results (`Money`, `NextStep`, `PayinStatus` and the rest), and the error types. |
| `PaymentSheet/` | The sheet's form definitions and their data, its state (`PaymentSheetModel`), its SwiftUI views, and the UIKit presenter. |
| `UI/` | The public Synqt-styled components and theme, icons and the loader. |
| `Support/` | Internal helpers: the JSON reader and localized string lookup. |
| `Resources/` | Strings, fonts and the privacy manifest. |

## Tests

`Tests/SynqtSDKTests` covers the models, the forms and their SA rules, parsing, error wording, and the loader's keyframes. Run them with `swift test` on a Mac, or on an iOS Simulator in Xcode with the package open (Product > Test).

## Running the demo

The demo app lives in the [synqt-examples](https://github.com/synqt-pay/synqt-examples) repo, under `ios/`. `SynqtDemo.xcodeproj` installs the released SDK, like an app. To build it from this checkout instead, clone that repo next to this checkout, with this repo in a folder named `ios`, and open `SynqtDemoLocal.xcworkspace`. Its README has the steps.

## Licence

This SDK is licensed under the Apache License 2.0; see `LICENSE` and `NOTICE`. The bundled fonts and icons come under their own licences (Instrument Sans under the SIL Open Font License, Phosphor icons under MIT), listed in `THIRD_PARTY_NOTICES.md`.

## Status

Built with Xcode 27.1 for the iOS Simulator with no warnings, and the test suite passes on it (58 tests). The package declares Swift tools 5.9, so it builds in Swift 5 language mode by default; forced into Swift 6 language mode (`SWIFT_VERSION=6`) it and the card add-on also build for the iOS Simulator without errors or warnings. The sheet has been opened in the Simulator from the demo app, in light and dark, with a placeholder token.
