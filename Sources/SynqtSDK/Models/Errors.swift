import Foundation

/// SYNQT refused a request. `errors` holds its reasons (for 406, the business errors such as INVALID_PHONE_NUMBER).
/// The raw response is not kept: SYNQT echoes what the payer typed in it, which must not reach logs.
public struct SynqtAPIError: Error, Equatable, LocalizedError, CustomStringConvertible {
    /// One reason SYNQT refused a request. `field` names the input it is about (SYNQT's attrCode), if any.
    public struct Reason: Equatable, Sendable {
        public let code: String
        public let field: String?
        public let description: String?
    }

    public let httpCode: Int
    public let errors: [Reason]

    public var description: String {
        "SYNQT HTTP \(httpCode)" + (errors.isEmpty ? "" : ": " + errors.map { $0.code + ($0.field.map { " (\($0))" } ?? "") }.joined(separator: ", "))
    }

    public var errorDescription: String? { description }
}

/// The app passed something the SDK cannot send: a malformed payin ID, an unknown method code, or a payment method
/// missing a field it needs (`path` names it when it is a form field).
public struct SynqtArgumentError: Error, Equatable, LocalizedError, CustomStringConvertible {
    public let message: String
    public let path: String?

    @_spi(SynqtAddon)
    public init(_ message: String, path: String? = nil) {
        self.message = message
        self.path = path
    }

    public var description: String { message }
    public var errorDescription: String? { message }
}
