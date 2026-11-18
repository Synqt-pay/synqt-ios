import Foundation

/**
 Entry point of the SYNQT payins SDK. Create one per environment, then one `Payin` per order:

 ```
 let payin = try Synqt(.sandbox).payin(token: token, payinID: payinID,
     money: Money(amount: 100, currencyCode: "ZAR"), returnURL: returnURL, callbackURL: callbackURL)
 let result = try await payin.presentPaymentSheet(from: viewController, paymentMethodCode: "CAPITEC_PAY")
 ```

 The token is minted per order by YOUR backend (POST /auth-tokens-by-action, action PAYIN_CREATE, with `money` set).
 The merchant private key and Secret key must never ship in the app. A payment is only paid when your backend's own
 GET /payins/{id} says SUCCESS; nothing the app sees is proof.
 */
public struct Synqt: Sendable {
    /// Where each SYNQT environment lives. The base URLs are public for backend calls such as minting tokens.
    public enum Environment: String, CaseIterable, Sendable {
        case sandbox
        /// SYNQT internal development platform, as in the WordPress plugin. Not for merchants.
        case stable
        case live

        public var apiBaseURL: String {
            switch self {
            case .sandbox: return "https://api.sandbox.synqt.io"
            case .stable: return "https://api.stable.aopay.io"
            case .live: return "https://api.synqt.io"
            }
        }

        public var paymentAppBaseURL: String {
            switch self {
            case .sandbox: return "https://payment.sandbox.synqt.io/"
            case .stable: return "https://payment.stable.aopay.io/"
            case .live: return "https://payment.synqt.io/"
            }
        }
    }

    public let environment: Environment
    private let session: URLSession

    public init(_ environment: Environment, session: URLSession = .shared) {
        self.environment = environment
        self.session = session
    }

    /// One order's payin. `payinID` is your own ID for it (letters, digits, `_` and `-`, at most 250) and must match the
    /// token. `returnURL` must be https: the Payment Web App rejects other schemes. Throws `SynqtArgumentError` otherwise.
    public func payin(token: String, payinID: String, money: Money, returnURL: String, callbackURL: String) throws -> Payin {
        guard payinID.count <= 250, payinID.range(of: "^[A-Za-z0-9_-]+$", options: .regularExpression) != nil else {
            throw SynqtArgumentError("payinID must match ^[A-Za-z0-9_-]+$, max 250")
        }
        guard URL(string: returnURL)?.scheme?.lowercased() == "https" else {
            throw SynqtArgumentError("returnURL must be https")
        }
        return Payin(synqt: self, token: token, id: payinID, money: money, returnURL: returnURL, callbackURL: callbackURL)
    }

    /// Every bank and provider SYNQT knows, with the providers behind each. SYNQT may add codes at any time, so treat
    /// unknown ones as normal. For what this merchant can use on a payin, use `Payin.availablePaymentOptions` instead.
    ///
    /// `token` must allow `GET /payment-operators`. PAYIN_CREATE tokens do not, so mint one on your backend with
    /// `POST /auth-tokens` and that operation.
    public func paymentOperators(token: String) async throws -> [PaymentOperator] {
        parseOperators(try JSON.parse(await call("GET", "/payment-operators", token: token))["data"])
    }

    /// Methods `Payin.presentPaymentSheet` can collect details for. Offer only those `Payin.availablePaymentOptions` also returns.
    public static var directPaymentMethods: [DirectPaymentMethod] {
        (methodForms.map(\.code) + Addons.shared.all.map(\.code)).map { DirectPaymentMethod(code: $0) }
    }

    /// Adds an add-on's method, such as the card add-on's CARD, to the sheet. Once is enough; adding it again replaces it.
    /// A built-in method can't be replaced.
    @_spi(SynqtAddon)
    public static func addMethod(_ method: any SheetMethod) {
        precondition(!methodForms.contains { $0.code == method.code }, "\(method.code) is already built in")
        Addons.shared.add(method)
    }

    func call(_ method: String, _ path: String, token: String, body: (any Encodable)? = nil) async throws -> Data {
        var request = URLRequest(url: URL(string: environment.apiBaseURL + path)!, timeoutInterval: 30)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("2", forHTTPHeaderField: "X-API-Version") // missing header gives 404, not 400
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        let (data, response) = try await session.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode ?? 0
        // The body is parsed into codes here and then dropped: 406 attrValue echoes what the payer typed.
        guard (200...299).contains(code) else { throw SynqtAPIError(httpCode: code, errors: parseErrors(data)) }
        return data
    }
}
