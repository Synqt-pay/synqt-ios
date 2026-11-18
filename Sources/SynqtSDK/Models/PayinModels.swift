import Foundation

/// An amount in major units (12.34, not 1234) and its ISO 4217 currency. IDR and INR take whole numbers only.
public struct Money: Codable, Equatable, Sendable, CustomStringConvertible {
    public let amount: Decimal
    public let currencyCode: String

    public init(amount: Decimal, currencyCode: String) {
        self.amount = amount
        self.currencyCode = currencyCode
    }

    /// R1,250.00 for rand, "USD 1,250.00" otherwise.
    public var description: String { formatMoney(amount, currencyCode) }
}

/// A payment method the SDK's payment sheet supports: `code` for the API, `name` to show the payer.
public struct DirectPaymentMethod: Equatable, Sendable {
    public let code: String

    /// The payer-facing name, in the phone's language where the SDK has a translation.
    public var name: String { methodName(code)! }
}

/// A method SYNQT offers this merchant, with the banks or providers to choose from.
public struct PaymentOption: Equatable, Sendable {
    public let code: String
    public let operators: [PaymentOperator]
    public let segmentCode: String?

    /// The payer-facing name in the phone's language, or nil for methods the sheet does not support.
    public var name: String? { methodName(code) }
}

/// A bank or provider: send `code`, show `name`. `externalProviders` are the providers it routes through, where SYNQT lists any.
public struct PaymentOperator: Equatable, Sendable {
    public let code: String
    public let name: String
    public let externalProviders: [ExternalProvider]

    public init(code: String, name: String, externalProviders: [ExternalProvider] = []) {
        self.code = code
        self.name = name
        self.externalProviders = externalProviders
    }
}

/// A provider behind a `PaymentOperator`: send `code` (for example as PayShap's `externalProviderCode`), show `name`.
public struct ExternalProvider: Equatable, Sendable {
    public let code: String
    public let name: String
}

/// What happened when a payin was created. Not proof of payment: check `Payin.status()` (and your backend) for that.
public enum CreatePayinResult: Equatable, Sendable {
    /// Send the payer to `url`. GET: open it. POST: submit a form to it with one field per `formData` entry (in a WKWebView).
    case redirect(httpMethod: String, url: String, formData: [String: String])

    /// Show these instructions yourself: QR code, deep link, account, reference, expiry, and moneyRequired if present
    /// (the payer must pay exactly that amount, so show it prominently). `nextStep` gathers the common ones;
    /// `Payin.presentPaymentSheet` already shows them.
    case instructions(paymentMethod: PaymentMethodResponse, nextStep: NextStep)
}

/// What the payer does next, from whichever of these fields the method returned. On this phone, open `appLink`; from
/// another phone, scan the image at `qrCodeImageURL` (a temporary link) or a QR code you draw from `qrCodeData`.
public struct NextStep: Equatable, Sendable {
    public var appLink: String?
    public var qrCodeImageURL: String?
    public var qrCodeData: String?
    /// If set, the payer must pay exactly this instead of the requested amount.
    public var amountToPay: Money?
    public var reference: String?
    /// ISO 8601. After this the payment fails and SYNQT sends a callback.
    public var expiresAt: String?
    /// For OFFLINE: the account the payer transfers to from their own banking app, quoting `reference`.
    public var payInto: PaymentMethodResponse.Account?
}

/// A payin's state from GET /payins/{id}.
public struct PayinStatus: Equatable, Sendable {
    public enum Status: String, Sendable {
        case processing = "PROCESSING", success = "SUCCESS", failed = "FAILED", refused = "REFUSED"
        /// A status this SDK version does not know yet. Treat it like processing.
        case unknown = "UNKNOWN"

        /// SUCCESS, FAILED and REFUSED do not change again.
        public var isFinal: Bool { self == .success || self == .failed || self == .refused }
    }

    public let status: Status
    public let requested: Money
    public let fee: Money?
    public let isTest: Bool
    public let failureReason: FailureReason?
    public let paymentMethod: PaymentMethodResponse?
    public let createdAt: String?
    public let processedAt: String?
}

/// Why a payin failed or was refused. `code` is one of SYNQT's FailureReasonCode values, such as ENTITY_EXPIRED.
public struct FailureReason: Equatable, Sendable {
    public let code: String
    /// SYNQT's own message, written for the merchant.
    public let message: String?
    public let failedAt: String?

    /// What to tell the payer, in the phone's language where the SDK has a translation.
    public var payerMessage: String { text(payerMessageKey(code) ?? "synqt_failure_general") }
}

/// Payer-facing wording (a string key) for SYNQT codes whose own description is meant for the merchant.
func payerMessageKey(_ code: String) -> String? { failureMessages[code] }

/// Rand as R1,250.00 (the synqt-output-format convention); other currencies as "USD 1,250.00". Keeps extra decimals the
/// amount really has, so nothing is rounded away.
func formatMoney(_ amount: Decimal, _ currencyCode: String) -> String {
    let plain = (amount as NSDecimalNumber).stringValue
    let decimals = plain.firstIndex(of: ".").map { plain.distance(from: $0, to: plain.endIndex) - 1 } ?? 0
    let digits = amount.formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2...max(2, decimals))))
    return currencyCode == "ZAR" ? "R\(digits)" : "\(currencyCode) \(digits)"
}
