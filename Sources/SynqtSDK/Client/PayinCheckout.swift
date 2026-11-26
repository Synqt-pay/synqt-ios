import Foundation

/**
 One order's payin for the ready-made screens, from `Synqt.checkout`: the payment sheet and SYNQT's hosted Payment Web
 App. To call the API yourself, use `IncomingPaymentsApi`. Calls throw `SynqtAPIError` when SYNQT refuses them, and
 `URLError` when it cannot be reached.
 */
public struct PayinCheckout: Sendable {
    let synqt: Synqt
    let token: String
    public let id: String
    public let money: MoneyPaymentRequested
    let returnURL: String
    let callbackURL: String?

    /// The API for this checkout's token, for add-ons that need more from SYNQT.
    @_spi(SynqtAddon)
    public var api: IncomingPaymentsApi { IncomingPaymentsApi(synqt: synqt, accessToken: token) }

    /// What the sheet sends: this checkout's payin with the payer's `paymentMethod`.
    func createPayin(_ paymentMethod: PaymentMethodPayin, customerIP: String?) async throws -> PayinAcceptedResponse {
        try await api.createPayin(idPayin: id, payin: Payin(paymentRequested: PaymentRequested(money: money), paymentMethod: paymentMethod,
                                                            returnUrl: returnURL, callbackUrl: callbackURL, customerIp: customerIP))
    }

    /// Link to SYNQT's hosted Payment Web App for this payin. `paymentMethodCode` opens it on that method (one
    /// `IncomingPaymentsApi.payinAvailablePaymentOptions` returns) while still letting the payer pick another.
    /// `prefill` takes the Payment Web App's own parameter names, such as `phoneNumber` or `emailAddress`, and the payer
    /// can still change them. `extra` adds any other parameter as given, after these.
    public func paymentAppURL(merchantCode: String, paymentMethodCode: String? = nil,
                              prefill: KeyValuePairs<String, String> = [:],
                              extra: KeyValuePairs<String, String> = [:]) -> String {
        var params = [("merchantCode", merchantCode), ("idPayin", id), ("token", token),
                      ("amount", (money.amount as NSDecimalNumber).stringValue), ("currencyCode", money.currencyCode)]
        if let callbackURL { params.append(("callbackUrl", callbackURL)) }
        params.append(("returnUrl", returnURL))
        if let paymentMethodCode { params += [("paymentMethodCode", paymentMethodCode), ("optionsAvailable", "true")] }
        if !prefill.isEmpty { params += prefill.map { ($0.key, $0.value) } + [("allowCustomerDataChange", "true")] }
        params += extra.map { ($0.key, $0.value) }
        return synqt.environment.paymentAppBaseURL + "?" + params.map { "\(enc($0.0))=\(enc($0.1))" }.joined(separator: "&")
    }

    /// Banks and providers for `form`'s bank or provider field (nil if they could not be loaded), and the merchant's name
    /// for the summary, which is a nicety: without it the summary leaves that row out.
    func sheetContext(for form: MethodForm) async -> (operators: [PaymentOperatorIncoming]?, merchant: String?) {
        async let operators: [PaymentOperatorIncoming]? = form.fields.contains { $0.kind == .operator || $0.kind == .provider }
            ? sheetOperators(for: form)
            : []
        async let merchant = try? JSON.parse(await synqt.call("GET", "/merchant-info", token: token))["channelInfo"]?["name"]?.text
        return await (operators, merchant ?? nil)
    }

    /// SYNQT's banks and providers for `form`, empty if it lists none, or nil if they could not be loaded. A failed
    /// connection or a SYNQT server error is tried twice more, 2 seconds apart; a refusal such as 403 is not.
    func sheetOperators(for form: MethodForm, retryAfter delay: UInt64 = 2_000_000_000) async -> [PaymentOperatorIncoming]? {
        for attempt in 0..<3 {
            if attempt > 0 {
                do { try await Task.sleep(nanoseconds: delay) } catch { return nil } // cancelled
            }
            do {
                let options = try await api.payinAvailablePaymentOptions(PaymentRequested(money: money)).data ?? []
                return options.first { $0.paymentMethodCode == form.code }?.paymentOperators ?? []
            } catch let refused as SynqtAPIError where refused.httpCode < 500 {
                return nil
            } catch {
                continue
            }
        }
        return nil
    }
}

/// As Java's URLEncoder leaves them, so the link matches the Android SDK's: letters, digits and `-._*`.
private let unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._*")

private func enc(_ value: String) -> String { value.addingPercentEncoding(withAllowedCharacters: unreserved) ?? value }
