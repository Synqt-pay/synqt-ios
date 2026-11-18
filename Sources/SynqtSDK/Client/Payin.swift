import Foundation

/**
 One order's payin, from `Synqt.payin`. Holds the token, ID, amount and URLs so each call needs only what is new.
 Calls throw `SynqtAPIError` when SYNQT refuses them, and `URLError` when it cannot be reached.
 */
public struct Payin: Sendable {
    let synqt: Synqt
    let token: String
    public let id: String
    public let money: Money
    let returnURL: String
    let callbackURL: String

    /// Creates the payin with a payment method you built yourself. `customerIP` is checked against the merchant's IP
    /// allow and deny lists, so pass the payer's real IP if you have it. A retry after a network failure is safe: if
    /// SYNQT already accepted this payin ID, the existing payin is fetched instead. If that payin was made with a
    /// different method, this throws `SynqtAPIError` (409, PAYIN_ALREADY_STARTED): start a new payin to pay another way.
    ///
    /// Throws `SynqtArgumentError` before sending if a shared type such as `PaymentMethod.Account` lacks a field this
    /// method needs, or has one it does not take.
    public func create(_ paymentMethod: PaymentMethod, customerIP: String? = nil) async throws -> CreatePayinResult {
        try paymentMethod.validate()
        return try await create(paymentMethod, code: paymentMethod.paymentMethodCode, customerIP: customerIP)
    }

    /// `create` with a `paymentMethod` object an add-on built, for methods this SDK has no type for.
    @_spi(SynqtAddon)
    public func create(_ paymentMethod: JSON, customerIP: String? = nil) async throws -> CreatePayinResult {
        try await create(paymentMethod, code: paymentMethod["paymentMethodCode"]?.text ?? "", customerIP: customerIP)
    }

    /// GET `path` with this payin's token, for add-ons that need more from SYNQT, such as the card encryption key.
    @_spi(SynqtAddon)
    public func get(_ path: String) async throws -> JSON {
        try JSON.parse(await synqt.call("GET", path, token: token))
    }

    private func create<M: Encodable>(_ paymentMethod: M, code: String, customerIP: String?) async throws -> CreatePayinResult {
        let body = CreateBody(paymentRequested: .init(money: money), paymentMethod: paymentMethod, returnUrl: returnURL,
                              callbackUrl: callbackURL, customerIp: customerIP)
        let data: Data
        do {
            data = try await synqt.call("POST", "/payins/\(id)", token: token, body: body)
        } catch let error as SynqtAPIError where error.httpCode == 409 {
            data = try await synqt.call("GET", "/payins/\(id)", token: token)
            try requireSameMethod(data, code)
        }
        return try parseCreatePayin(data)
    }

    /// Methods, banks and providers SYNQT offers this merchant for `money`. Send the same `segmentCode` when paying.
    public func availablePaymentOptions(segmentCode: String? = nil) async throws -> [PaymentOption] {
        let body = OptionsBody(money: money, segmentCode: segmentCode)
        return parsePaymentOptions(try JSON.parse(await synqt.call("POST", "/payins/!availablePaymentOptions", token: token, body: body)))
    }

    /// For display only. Fulfil orders from your backend's own status check, never from this.
    public func status() async throws -> PayinStatus {
        parsePayinStatus(try JSON.parse(await synqt.call("GET", "/payins/\(id)", token: token)))
    }

    /// The payer's bank or UTR reference, for methods that need it. The token must allow `POST /payins/{id}/!setExternalReference`.
    public func setExternalReference(_ reference: String) async throws {
        guard (1...512).contains(reference.count) else { throw SynqtArgumentError("reference must be 1...512 characters") }
        _ = try await synqt.call("POST", "/payins/\(id)/!setExternalReference", token: token, body: ["reference": reference])
    }

    /// Link to SYNQT's hosted Payment Web App for this payin. `paymentMethodCode` opens it on that method (one
    /// `availablePaymentOptions` returns) while still letting the payer pick another. `prefill` takes the Payment Web
    /// App's own parameter names, such as `phoneNumber` or `emailAddress`, and the payer can still change them.
    /// `extra` adds any other parameter as given, after these.
    public func paymentAppURL(merchantCode: String, paymentMethodCode: String? = nil,
                              prefill: KeyValuePairs<String, String> = [:],
                              extra: KeyValuePairs<String, String> = [:]) -> String {
        var params = [("merchantCode", merchantCode), ("idPayin", id), ("token", token),
                      ("amount", (money.amount as NSDecimalNumber).stringValue), ("currencyCode", money.currencyCode),
                      ("callbackUrl", callbackURL), ("returnUrl", returnURL)]
        if let paymentMethodCode { params += [("paymentMethodCode", paymentMethodCode), ("optionsAvailable", "true")] }
        if !prefill.isEmpty { params += prefill.map { ($0.key, $0.value) } + [("allowCustomerDataChange", "true")] }
        params += extra.map { ($0.key, $0.value) }
        return synqt.environment.paymentAppBaseURL + "?" + params.map { "\(enc($0.0))=\(enc($0.1))" }.joined(separator: "&")
    }

    /// Banks and providers for `form`'s bank or provider field, and the merchant's name for the summary. Both are
    /// niceties: without the bank list the sheet hides an optional bank field or asks for the code, and without the
    /// merchant name the summary leaves that row out.
    func sheetContext(for form: MethodForm) async -> (operators: [PaymentOperator], merchant: String?) {
        async let operators: [PaymentOperator] = form.fields.contains { $0.kind == .operator || $0.kind == .provider }
            ? ((try? await availablePaymentOptions().first { $0.code == form.code }?.operators) ?? [])
            : []
        async let merchant = try? JSON.parse(await synqt.call("GET", "/merchant-info", token: token))["channelInfo"]?["name"]?.text
        return await (operators, merchant ?? nil)
    }
}

private struct CreateBody<Method: Encodable>: Encodable {
    struct Requested: Encodable { let money: Money }
    let paymentRequested: Requested
    let paymentMethod: Method
    // SYNQT's JSON names.
    let returnUrl: String
    let callbackUrl: String
    let customerIp: String?
}

private struct OptionsBody: Encodable {
    let money: Money
    let segmentCode: String?
}

/// As Java's URLEncoder leaves them, so the link matches the Android SDK's: letters, digits and `-._*`.
private let unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._*")

private func enc(_ value: String) -> String { value.addingPercentEncoding(withAllowedCharacters: unreserved) ?? value }
