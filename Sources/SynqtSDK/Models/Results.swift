import Foundation

// Helpers on the generated payin models (PayinModels.swift, PaymentMethods.swift).

extension MoneyPaymentRequested {
    /// R1,250.00 for rand, "USD 1,250.00" otherwise.
    public func format() -> String { formatMoney(amount, currencyCode) }
}

extension PaymentMethodResponsePayin.Money {
    /// R1,250.00 for rand, "USD 1,250.00" otherwise; nil without an amount.
    public func format() -> String? { amount.map { formatMoney($0, currencyCode ?? "") } }
}

/// A payment method the SDK's payment sheet supports: `code` for the API, `name` to show the payer.
public struct DirectPaymentMethod: Equatable, Sendable {
    public let code: String

    /// The payer-facing name, in the phone's language where the SDK has a translation.
    public var name: String { methodName(code)! }
}

extension AvailablePayinOption {
    /// The payer-facing name of this option's method in the phone's language, or nil for methods the sheet does not support.
    public var name: String? { methodName(paymentMethodCode) }
}

/// What the payer does next, from whichever of these fields the method returned. On this phone, open `appLink`; from
/// another phone, scan the image at `qrCodeImageURL` (a temporary link) or a QR code you draw from `qrCodeData`.
/// Every `PaymentMethodResponsePayin` gives one with `nextStep()`; `PayinCheckout.presentPaymentSheet` already shows it.
public struct NextStep: Equatable, Sendable {
    public var appLink: String?
    public var qrCodeImageURL: String?
    public var qrCodeData: String?
    /// If set, the payer must pay exactly this instead of the requested amount.
    public var amountToPay: PaymentMethodResponsePayin.Money?
    public var reference: String?
    /// ISO 8601. After this the payment fails and SYNQT sends a callback.
    public var expiresAt: String?
    /// For OFFLINE: the account the payer transfers to from their own banking app, quoting `reference`.
    public var payInto: PaymentMethodResponsePayin.Account?
}

extension PayinAcceptedResponse {
    /// The next step of a payin SYNQT accepted with instructions, or nil when it sent a redirect instead.
    public func nextStep() -> NextStep? {
        guard case .methodResponse(let accepted) = self else { return nil }
        return accepted.paymentMethodResponse?.nextStep()
    }

    /// Where to send the payer, if anywhere: SYNQT's `redirectTo`, or a card's 3-D Secure page (CARD comes from the
    /// card add-on). GET: open `url`. POST: submit a form to it with `formData()`'s fields (in a WKWebView).
    public func redirect() -> Redirection? {
        switch self {
        case .redirectResponse(let accepted): return accepted.redirectTo
        // FORM, CONTENT and OTP_REQUIRED stay on the method response for the app to show.
        case .methodResponse(let accepted):
            guard case .card(let card)? = accepted.paymentMethodResponse, case .redirect(let redirect)? = card.userInteraction,
                  let url = redirect.url else { return nil }
            return Redirection(method: "GET", url: url, data: nil)
        }
    }
}

extension Redirection {
    /// The fields to POST to `url`: SYNQT sends them as a JSON string in `data`.
    public func formData() -> [String: String] {
        guard let data, let json = try? JSON.parse(Data(data.utf8)) else { return [:] }
        return json.fields.mapValues { $0.text ?? "" }
    }
}

/// SYNQT's payment statuses (`PaymentProcess.status`). New ones may come; treat an unknown status like `processing`.
public enum PaymentStatus {
    public static let processing = "PROCESSING"
    public static let success = "SUCCESS"
    public static let failed = "FAILED"
    public static let refused = "REFUSED"
}

extension PayinDetail {
    /// SUCCESS, FAILED and REFUSED, which do not change again. For display only: fulfil orders from your backend's own check.
    public var isFinal: Bool {
        [PaymentStatus.success, PaymentStatus.failed, PaymentStatus.refused].contains(process?.status ?? "")
    }
}

extension FailureReasons {
    /// What to tell the payer, in the phone's language where the SDK has a translation. `message` is SYNQT's own,
    /// written for the merchant.
    public var payerMessage: String { text(failureReasonCode.flatMap(payerMessageKey) ?? "synqt_failure_general") }
}

/// Payer-facing wording (a string key) for SYNQT codes whose own description is meant for the merchant.
func payerMessageKey(_ code: String) -> String? { failureMessages[code] }

// Every deep link field in the spec; a method returns at most one.
private let appLinkFields = ["deepLink", "zapperQrDeepLink", "snapscanQrDeepLink", "upiQrDeepLink", "payMeDeepLink"]

/// The next step of a method this SDK version doesn't know, from the field names every method uses. No `payInto`:
/// only OFFLINE's account is one to pay into, and OFFLINE is never unknown.
func parseNextStep(_ data: Data) -> NextStep {
    guard let response = try? JSON.parse(data) else { return NextStep() }
    return NextStep(
        appLink: appLinkFields.lazy.compactMap { response[$0]?.text }.first,
        qrCodeImageURL: response["qrCode"]?.text,
        qrCodeData: response["qrRawData"]?.text,
        amountToPay: response["moneyRequired"]?.decode(PaymentMethodResponsePayin.Money.self),
        reference: response["reference"]?.text,
        expiresAt: response["expireAt"]?.text
    )
}

/// Rand as R1,250.00 (the synqt-output-format convention); other currencies as "USD 1,250.00". Keeps extra decimals the
/// amount really has, so nothing is rounded away.
func formatMoney(_ amount: Decimal, _ currencyCode: String) -> String {
    let plain = (amount as NSDecimalNumber).stringValue
    let decimals = plain.firstIndex(of: ".").map { plain.distance(from: $0, to: plain.endIndex) - 1 } ?? 0
    let digits = amount.formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2...max(2, decimals))))
    return currencyCode == "ZAR" ? "R\(digits)" : "\(currencyCode) \(digits)"
}
