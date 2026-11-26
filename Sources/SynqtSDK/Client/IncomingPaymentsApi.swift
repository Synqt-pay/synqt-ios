import Foundation

/**
 SYNQT's incoming payments (payin) API, as in the Carpentum Java SDK's `IncomingPaymentsApi`: one instance per token,
 each call naming the payin it is about.

 ```
 let api = IncomingPaymentsApi(synqt: Synqt(.sandbox), accessToken: token)
 let requested = PaymentRequested(money: MoneyPaymentRequested(amount: 100, currencyCode: "ZAR"))
 let accepted = try await api.createPayin(idPayin: payinID, payin: Payin(paymentRequested: requested,
     paymentMethod: .capitecPay(.init(phoneNumber: "0821234567")), returnUrl: returnURL))
 ```

 The token is minted by YOUR backend, which holds the merchant's private key (POST /auth-tokens-by-action with action
 PAYIN_CREATE and `money` set allows every call here for that payin). Calls throw `SynqtAPIError` when SYNQT refuses
 them, and `URLError` when it cannot be reached.
 */
public struct IncomingPaymentsApi: Sendable {
    let synqt: Synqt
    let token: String

    /// An API for `accessToken`, on `synqt`'s environment. As the Java SDK's `IncomingPaymentsApi.create(context, token)`.
    public init(synqt: Synqt, accessToken: String) {
        self.synqt = synqt
        self.token = accessToken
    }

    /// Methods, banks and providers SYNQT offers this merchant for `paymentRequested`. Send the same `segmentCode` when paying.
    public func payinAvailablePaymentOptions(_ paymentRequested: PaymentRequested) async throws -> AvailablePayinOptionList {
        try decode(await synqt.call("POST", "/payins/!availablePaymentOptions", token: token, body: paymentRequested))
    }

    /// Creates payin `idPayin` (your own ID for the order: letters, digits, `_` and `-`, at most 250, matching the
    /// token). Not proof of payment: see `getPayin` and your backend's own check.
    ///
    /// A retry after a network failure is safe: if SYNQT already accepted `idPayin`, the existing payin is returned. If
    /// that payin was made with a different method, this throws `SynqtAPIError` (409, PAYIN_ALREADY_STARTED): start a
    /// new payin to pay another way.
    ///
    /// Throws `SynqtArgumentError` before sending if `idPayin` is not a valid ID, `returnUrl` is not https, or a shared
    /// type such as `PaymentMethodPayin.Account` lacks a field the method needs or has one it does not take.
    public func createPayin(idPayin: String, payin: Payin) async throws -> PayinAcceptedResponse {
        try Self.checkID(idPayin)
        try Self.checkReturnURL(payin.returnUrl)
        try payin.paymentMethod.validate()
        let data: Data
        do {
            data = try await synqt.call("POST", "/payins/\(idPayin)", token: token, body: payin)
        } catch let error as SynqtAPIError where error.httpCode == 409 {
            // GET /payins/{id} carries paymentRequested and paymentMethodResponse, as the accepted response does.
            data = try await synqt.call("GET", "/payins/\(idPayin)", token: token)
            try requireSameMethod(data, payin.paymentMethod.paymentMethodCode)
        }
        return try decode(data)
    }

    /// The payer's bank or UTR reference, for methods that need it. The token must allow `POST /payins/{id}/!setExternalReference`.
    public func setPayinExternalReference(idPayin: String, reference: String) async throws {
        try Self.checkID(idPayin)
        guard (1...512).contains(reference.count) else { throw SynqtArgumentError("reference must be 1...512 characters") }
        _ = try await synqt.call("POST", "/payins/\(idPayin)/!setExternalReference", token: token, body: ["reference": reference])
    }

    /// Payin `idPayin` as SYNQT has it now. For display only: fulfil orders from your backend's own check, never from this.
    public func getPayin(idPayin: String) async throws -> PayinDetail {
        try Self.checkID(idPayin)
        return try decode(await synqt.call("GET", "/payins/\(idPayin)", token: token))
    }

    /// The payer's account as they entered it and as the payment used it. The token must allow `GET /payins/{id}/accounts`.
    public func getPayinAccounts(idPayin: String) async throws -> PaymentAccountDetail {
        try Self.checkID(idPayin)
        return try decode(await synqt.call("GET", "/payins/\(idPayin)/accounts", token: token))
    }

    /// GET `path` with this token, for add-ons that need more from SYNQT, such as the card encryption key.
    @_spi(SynqtAddon)
    public func get(_ path: String) async throws -> JSON {
        try JSON.parse(await synqt.call("GET", path, token: token))
    }

    private func decode<T: Decodable>(_ data: Data) throws -> T { try JSONDecoder().decode(T.self, from: data) }

    static func checkID(_ id: String) throws {
        guard id.count <= 250, id.range(of: "^[A-Za-z0-9_-]+$", options: .regularExpression) != nil else {
            throw SynqtArgumentError("idPayin must match ^[A-Za-z0-9_-]+$, max 250")
        }
    }

    /// The Payment Web App rejects other schemes.
    static func checkReturnURL(_ url: String) throws {
        guard URL(string: url)?.scheme?.lowercased() == "https" else { throw SynqtArgumentError("returnURL must be https") }
    }
}
