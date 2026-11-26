# Changelog

## 0.3.0 (Unreleased)

First public release, at `https://github.com/synqt-pay/synqt-ios`. Versions restart at 0.3.0, in step with the other SYNQT SDKs.

- Synqt-branded payment sheet that asks the payer for exactly what their payment method needs, sends the payment and shows the next step (open the payment app, QR code, Pay offline transfer details, time left to pay).
- Direct SYNQT API (version 2, spec 2.84) for every payment method except CARD: `IncomingPaymentsApi`, with the Carpentum Java SDK's payin calls and models (`payinAvailablePaymentOptions`, `createPayin(idPayin:payin:)`, `getPayin`, `getPayinAccounts` and `setPayinExternalReference`), returning SYNQT's full `PayinAcceptedResponse` and `PayinDetail`. `PayinCheckout` (from `Synqt.checkout`) runs the payment sheet and the Payment Web App.
- The hosted Payment Web App, shown in-app.
- Synqt-styled SwiftUI components and theme, with light and dark mode and localisable strings.
- Add-on API for the card add-on, available to PCI DSS compliant merchants on request from SYNQT.
