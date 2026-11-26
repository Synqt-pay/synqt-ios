import Foundation

/// What SYNQT accepted: the variant is chosen by which field it sent.
public enum PayinAcceptedResponse: Decodable, Equatable, Sendable {
    /// SYNQT sent `paymentMethodResponse`.
    case methodResponse(PayinAcceptedMethodResponse)
    /// SYNQT sent `redirectTo`.
    case redirectResponse(PayinAcceptedRedirectResponse)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Field.self)
        if container.contains(.paymentMethodResponse) {
            self = .methodResponse(try PayinAcceptedMethodResponse(from: decoder))
        } else if container.contains(.redirectTo) {
            self = .redirectResponse(try PayinAcceptedRedirectResponse(from: decoder))
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "PayinAcceptedResponse has none of paymentMethodResponse, redirectTo"))
        }
    }

    private enum Field: String, CodingKey { case paymentMethodResponse, redirectTo }
}

public struct AccountResponseDetail: Decodable, Equatable, Sendable {
    /// Name of the bank account. min 1, max 64, pattern `^(\p{L}\p{M}*?|[\d, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$`.
    public let accountName: String?
    /// Number of the bank account.
    public let accountNumber: String?
    /// Type of the bank account. min 1, max 64, pattern `^(\p{L}\p{M}*?|[, ;:_'"!%=@#&\-\.\?\$\(\)\+\*\|])*$`.
    public let accountType: String?
    /// Bank code of the bank. min 1.
    public let bankCode: String?
    /// Payment operator code.
    public let paymentOperator: PaymentOperatorIncoming?
    /// Name of the bank. min 1.
    public let bankName: String?
    /// Branch name of the bank. min 1.
    public let bankBranch: String?
    /// City of the bank. min 1.
    public let bankCity: String?
    /// Province of the bank. min 1.
    public let bankProvince: String?
}

public struct AvailablePayinOption: Decodable, Equatable, Sendable {
    /// Payment method is a payment instrument that your customers use (such as online bank transfers, VA payments, UPI and so on). min 1. Always present per spec.
    public let paymentMethodCode: String?
    public let paymentOperators: [PaymentOperatorIncoming]?
    /// A customer segment which allows you to divide your customers into groups that reflect similarity among customers in each group. min 1.
    public let segmentCode: String?
}

/// The list of possible payment options. The list always contains at least one payment option.
public struct AvailablePayinOptionList: Decodable, Equatable, Sendable {
    public let data: [AvailablePayinOption]?
    public let dataVariantCurrencies: [AvailablePayinOptionVariantCurrency]?
}

public struct AvailablePayinOptionVariantCurrency: Decodable, Equatable, Sendable {
    /// Payment method is a payment instrument that your customers use (such as online bank transfers, VA payments, UPI and so on). min 1. Always present per spec.
    public let paymentMethodCode: String?
    public let paymentOperators: [PaymentOperatorIncoming]?
    /// A customer segment which allows you to divide your customers into groups that reflect similarity among customers in each group. min 1.
    public let segmentCode: String?
    /// Always present per spec.
    public let money: Money?
}

/// Customer related to this payment.
public struct CustomerDetail: Decodable, Equatable, Sendable {
    /// The ID of customer given by merchant. min 1, max 250.
    public let idCustomer: String?
}

/// TODO: Add description
public struct ExternalProvider: Decodable, Equatable, Sendable {
    /// min 1, max 128. Always present per spec.
    public let code: String?
    /// min 1. Always present per spec.
    public let name: String?
}

public struct ExternalProviders: Decodable, Equatable, Sendable {
    public let providers: [ExternalProvider]?
}

public struct FailureReasons: Decodable, Equatable, Sendable {
    /// Date and time of the payment failure. date-time. Always present per spec.
    public let failedAt: String?
    /// * `SYSTEM` - Internal error. one of SYSTEM, PAYMENT_PROCESS_ERROR, ENTITY_EXPIRED, DIFFERENT_AMOUNT_CONFIRMED, CURRENCY_NOT_SUPPORTED, CURRENCY_PRECISION_EXCEEDED, PAYMENT_METHOD_NOT_FOUND, PAYMENT_METHOD_ERROR, PAYMENT_OPERATOR_NOT_FOUND, PAYMENT_OPERATOR_INVALID, PAYMENT_OPERATOR_UNAVAILABLE, PAYMENT_CHANNEL_NO_ACTIVE_FOUND, PAYMENT_CHANNEL_NO_OPENED_FOUND, PAYMENT_CHANNEL_NO_SEGMENT_FOUND, PAYMENT_CHANNEL_AMOUNT_LIMITS, PAYMENT_CHANNEL_DAILY_LIMITS, IP_DENIED, BALANCE_INSUFFICIENT, INVALID_ACCOUNT_NUMBER, INVALID_ACCOUNT_NAME, INVALID_PHONE_NUMBER, INVALID_ID_NUMBER, INCORRECT_CURRENCY, CUSTOMER_VERIFICATION_REJECTED, CUSTOMER_VERIFICATION_FAILED, ACCOUNT_TYPE_INELIGIBLE, NAME_SIMILARITY_CHECK_FAILED, INVALID_IFSC, FEATURE_UNAVAILABLE, CUSTOMER_ACCOUNT_LIMIT_EXCEEDED, CUSTOMER_VERIFICATION_INACTIVITY, CUSTOMER_NOT_REGISTERED, SECURITY_CHECK_FAILED, VOUCHER_INELIGIBLE. Always present per spec.
    public let failureReasonCode: String?
    /// Additional description of the failure reason.
    public let message: String?
}

public struct Money: Decodable, Equatable, Sendable {
    /// Amount is accepted in the smallest currency unit. Always present per spec.
    public let amount: Decimal?
    /// For supported currencies please refer to `GET /currencies`. min 1. Always present per spec.
    public let currencyCode: String?
}

/// Fees charged for this payment.
public struct MoneyFee: Decodable, Equatable, Sendable {
    /// Amount is accepted in the smallest currency unit. Always present per spec.
    public let amount: Decimal?
    /// For supported currencies please refer to `GET /currencies`. min 1. Always present per spec.
    public let currencyCode: String?
}

public struct MoneyPaymentRequested: Encodable, Decodable, Equatable, Sendable {
    /// Requested payment amount.
    public let amount: Decimal
    /// For supported currencies please refer to `GET /currencies`. min 1.
    public let currencyCode: String

    public init(amount: Decimal, currencyCode: String) {
        self.amount = amount
        self.currencyCode = currencyCode
    }
}

/// For every payment method there is appropriate payment specific request object in `paymentMethod` attribute. If you have used the `POST /payins/!availablePaymentOptions` API to get the list of the available payment options, then it is expected that you use the same input data here to make sure that the payment will be accepted.
public struct Payin: Encodable, Equatable, Sendable {
    /// The requested payment.
    public let paymentRequested: PaymentRequested
    /// Payment method is a payment instrument that your customers use (such as online bank transfers, VA payments, UPI and so on).
    public let paymentMethod: PaymentMethodPayin
    /// This is the URL where the customers will be redirected after completing a payment. max 1000.
    public let returnUrl: String
    /// This is the URL where the system will send the transaction final status after payment has been completed. max 1000.
    public let callbackUrl: String?
    /// The IP address of the customer making the payment in either the IPv4 or IPv6 format.
    public let customerIp: String?

    public init(paymentRequested: PaymentRequested, paymentMethod: PaymentMethodPayin, returnUrl: String, callbackUrl: String? = nil, customerIp: String? = nil) {
        self.paymentRequested = paymentRequested
        self.paymentMethod = paymentMethod
        self.returnUrl = returnUrl
        self.callbackUrl = callbackUrl
        self.customerIp = customerIp
    }
}

/// For every payment method there is appropriate payment specific response object in `paymentMethodResponse` attribute. Use data from `paymentMethodResponse` for payment completion (for example show to the customer).
public struct PayinAcceptedMethodResponse: Decodable, Equatable, Sendable {
    /// The requested payment. Always present per spec.
    public let paymentRequested: PaymentRequested?
    /// Always present per spec.
    public let paymentMethodResponse: PaymentMethodResponsePayin?
}

/// Customer should be redirected to specified URL for the next payment process step.
public struct PayinAcceptedRedirectResponse: Decodable, Equatable, Sendable {
    /// The requested payment. Always present per spec.
    public let paymentRequested: PaymentRequested?
    /// Always present per spec.
    public let redirectTo: Redirection?
}

public struct PayinDetail: Decodable, Equatable, Sendable {
    /// The requested payment. Always present per spec.
    public let paymentRequested: PaymentRequested?
    /// Always present per spec.
    public let process: PaymentProcess?
    /// Fees charged for this payment. Always present per spec.
    public let fee: MoneyFee?
    /// Always present per spec.
    public let paymentMethodResponse: PaymentMethodResponsePayin?
    /// Payment method is a payment instrument that your customers use (such as online bank transfers, VA payments, UPI and so on).
    public let settlement: SettlementMethod?
    /// Customer related to this payment.
    public let customer: CustomerDetail?
}

public struct PaymentAccountDetail: Decodable, Equatable, Sendable {
    /// Details of customer's account collected in payment request. Always present per spec.
    public let customerAccountRequest: AccountResponseDetail?
    /// Details of customer's account collected during payment process. Always present per spec.
    public let customerAccountProcess: AccountResponseDetail?
}

public struct PaymentOperatorIncoming: Decodable, Equatable, Sendable {
    /// One of following can serve as Payment Operator: min 1, max 30, pattern `^[A-Za-z0-9_-]+$`. Always present per spec.
    public let code: String?
    /// min 1, max 1000. Always present per spec.
    public let name: String?
    public let externalProviders: ExternalProviders?
}

public struct PaymentProcess: Decodable, Equatable, Sendable {
    /// * `PROCESSING` - payment process is not finished yet. one of PROCESSING, SUCCESS, FAILED, REFUSED. Always present per spec.
    public let status: String?
    public let failureReasons: FailureReasons?
    /// Date and time when payment was accepted by platform. date-time. Always present per spec.
    public let createdAt: String?
    /// Date and time when payment was processed by platform. date-time.
    public let processedAt: String?
    /// This flag is set to `true` when payment was done with testing merchant or testing channel. Always present per spec.
    public let isTest: Bool?
    /// If present, this field specifies the status of the payment processing by an external processor. one of ACCEPTED, PROCESSED.
    public let processorStatus: String?
}

/// The requested payment.
public struct PaymentRequested: Encodable, Decodable, Equatable, Sendable {
    public let money: MoneyPaymentRequested
    /// A customer segment which allows you to divide your customers into groups that reflect similarity among customers in each group. min 1.
    public let segmentCode: String?
    /// For supported currencies please refer to `GET /currencies`. min 1.
    public let exchangedToCurrency: String?

    public init(money: MoneyPaymentRequested, segmentCode: String? = nil, exchangedToCurrency: String? = nil) {
        self.money = money
        self.segmentCode = segmentCode
        self.exchangedToCurrency = exchangedToCurrency
    }
}

public struct Redirection: Decodable, Equatable, Sendable {
    /// The HTTP method that should be used for redirection. one of GET, POST. Always present per spec.
    public let method: String?
    /// The destination URL for redirect to. Always present per spec.
    public let url: String?
    /// The optional data in JSON format - a key-value pairs that must be used for redirection when POST method is used.
    public let data: String?
}
