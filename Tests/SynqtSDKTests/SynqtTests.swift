import XCTest
@_spi(SynqtAddon) @testable import SynqtSDK

final class SynqtTests: XCTestCase {

    private let money = MoneyPaymentRequested(amount: Decimal(string: "12.30")!, currencyCode: "ZAR")

    private func checkout(_ id: String = "order-1") throws -> PayinCheckout {
        try Synqt(.sandbox).checkout(token: "a.b+c", payinID: id, money: money, returnURL: "https://x.io/return", callbackURL: "https://x.io/cb")
    }

    private func decode<T: Decodable>(_ type: T.Type, _ body: String) throws -> T { try JSONDecoder().decode(type, from: Data(body.utf8)) }

    func testPaymentAppUrlEncodesParams() throws {
        XCTAssertEqual(
            "https://payment.sandbox.synqt.io/?merchantCode=MID&idPayin=order-1&token=a.b%2Bc&amount=12.3" +
                "&currencyCode=ZAR&callbackUrl=https%3A%2F%2Fx.io%2Fcb&returnUrl=https%3A%2F%2Fx.io%2Freturn&emailAddress=a%40b.co",
            try checkout().paymentAppURL(merchantCode: "MID", extra: ["emailAddress": "a@b.co"])
        )
        // Without a callback URL the parameter is left out.
        let noCallback = try Synqt(.sandbox).checkout(token: "t", payinID: "order-1", money: money, returnURL: "https://x.io/return")
        XCTAssertFalse(noCallback.paymentAppURL(merchantCode: "MID").contains("callbackUrl"))
    }

    func testPaymentAppOffersAMethodAndEditablePrefill() throws {
        let url = try checkout().paymentAppURL(merchantCode: "MID", paymentMethodCode: "CAPITEC_PAY", prefill: ["phoneNumber": "+27821234567"])
        XCTAssertTrue(url.hasSuffix("&paymentMethodCode=CAPITEC_PAY&optionsAvailable=true&phoneNumber=%2B27821234567&allowCustomerDataChange=true"), url)
        XCTAssertFalse(try checkout().paymentAppURL(merchantCode: "MID").contains("optionsAvailable"))
    }

    func testRejectsUnsafeId() {
        XCTAssertThrowsError(try checkout("../x"))
    }

    func testReturnURLMustBeHttps() {
        for bad in ["http://x.io/return", "myapp://return", "x.io/return"] {
            XCTAssertThrowsError(try Synqt(.sandbox).checkout(token: "t", payinID: "o-1", money: money, returnURL: bad), bad)
        }
    }

    func testPayinRequestHasTheJavaSdksShape() throws {
        let payin = Payin(paymentRequested: PaymentRequested(money: money, segmentCode: "S1"),
                          paymentMethod: .capitecPay(.init(phoneNumber: "0821234567")), returnUrl: "https://x.io/return", customerIp: "10.0.0.1")
        let json = try JSON.parse(JSONEncoder().encode(payin))
        XCTAssertEqual(["customerIp", "paymentMethod", "paymentRequested", "returnUrl"], json.fields.keys.sorted()) // callbackUrl is optional
        XCTAssertEqual("S1", json["paymentRequested"]?["segmentCode"]?.text)
        XCTAssertEqual("ZAR", json["paymentRequested"]?["money"]?["currencyCode"]?.text)
        XCTAssertEqual(.number(Decimal(string: "12.3")!), json["paymentRequested"]?["money"]?["amount"])
        XCTAssertEqual("CAPITEC_PAY", json["paymentMethod"]?["paymentMethodCode"]?.text)
        // An add-on's method goes as it built it.
        let card = PaymentMethodPayin.addon(.init(paymentMethodCode: "CARD", json: .object(["paymentMethodCode": .string("CARD"), "card": .object([:])])))
        XCTAssertEqual(.object(["paymentMethodCode": .string("CARD"), "card": .object([:])]), try JSON.parse(JSONEncoder().encode(card)))
        XCTAssertEqual("CARD", card.paymentMethodCode)
    }

    func testAcceptedResponseIsChosenByTheFieldSynqtSent() throws {
        let redirect = try decode(PayinAcceptedResponse.self, #"""
            {"paymentRequested":{"money":{"amount":12.3,"currencyCode":"ZAR"}},
             "redirectTo":{"method":"POST","url":"https://p.io","data":"{\"k\":\"v\",\"n\":1}"}}
            """#)
        guard case .redirectResponse(let redirected) = redirect else { return XCTFail("\(redirect)") }
        XCTAssertEqual("ZAR", redirected.paymentRequested?.money.currencyCode)
        XCTAssertEqual(["k": "v", "n": "1"], redirect.redirect()?.formData())
        XCTAssertNil(redirect.nextStep())

        let method = try decode(PayinAcceptedResponse.self, #"{"paymentMethodResponse":{"paymentMethodCode":"PAYSHAP","reference":"REF1"}}"#)
        guard case .methodResponse(let accepted) = method, case .payShap(let payShap)? = accepted.paymentMethodResponse else { return XCTFail("\(method)") }
        XCTAssertEqual("REF1", payShap.reference)
        XCTAssertEqual("REF1", method.nextStep()?.reference)
        XCTAssertNil(method.redirect())
        XCTAssertThrowsError(try decode(PayinAcceptedResponse.self, "{}"))
    }

    func testParsesPayinDetail() throws {
        let detail = try decode(PayinDetail.self, #"""
            {"paymentRequested":{"money":{"amount":100.50,"currencyCode":"ZAR"}},"fee":{"amount":2,"currencyCode":"ZAR"},
               "process":{"status":"FAILED","isTest":true,"createdAt":"2026-10-26T10:00:00Z",
                 "failureReasons":{"failureReasonCode":"ENTITY_EXPIRED","message":"Expired","failedAt":"2026-10-26T12:00:00Z"}},
               "paymentMethodResponse":{"paymentMethodCode":"CAPITEC_PAY"},
               "settlement":{"paymentMethodCode":"CRYPTO_TRANSFER","paymentOperatorCode":"OP","account":{"accountNumber":"A1"}},
               "customer":{"idCustomer":"C1"}}
            """#)
        XCTAssertEqual(PaymentStatus.failed, detail.process?.status)
        XCTAssertTrue(detail.isFinal && detail.process?.isTest == true)
        XCTAssertEqual(Decimal(string: "100.5"), detail.paymentRequested?.money.amount)
        XCTAssertEqual("ENTITY_EXPIRED", detail.process?.failureReasons?.failureReasonCode)
        guard case .capitecPay = detail.paymentMethodResponse else { return XCTFail() }
        guard case .cryptoTransfer(let settlement) = detail.settlement else { return XCTFail() }
        XCTAssertEqual("OP", settlement.paymentOperatorCode)
        XCTAssertEqual("C1", detail.customer?.idCustomer)
    }

    func testUnknownStatusIsNotFinal() throws {
        XCTAssertFalse(try decode(PayinDetail.self, #"{"process":{"status":"ON_HOLD"}}"#).isFinal)
    }

    // Over HTTP, against a stub standing in for SYNQT.

    private func api(_ answers: (Int, String)...) -> IncomingPaymentsApi {
        StubAPI.answers = answers
        StubAPI.received = []
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubAPI.self]
        return IncomingPaymentsApi(synqt: Synqt(.sandbox, session: URLSession(configuration: config)), accessToken: "t")
    }

    private var capitec: Payin {
        Payin(paymentRequested: PaymentRequested(money: money), paymentMethod: .capitecPay(.init(phoneNumber: "0821234567")), returnUrl: "https://x.io/return")
    }

    func testCreatePayinPostsThePayinAndReturnsWhatSynqtAccepted() async throws {
        let accepted = try await api((201, #"{"paymentRequested":{"money":{"amount":12.3,"currencyCode":"ZAR"}},"paymentMethodResponse":{"paymentMethodCode":"CAPITEC_PAY"}}"#))
            .createPayin(idPayin: "order-1", payin: capitec)
        guard case .methodResponse = accepted else { return XCTFail("\(accepted)") }
        let request = try XCTUnwrap(StubAPI.received.first)
        XCTAssertEqual(1, StubAPI.received.count)
        XCTAssertEqual("POST /payins/order-1", "\(request.method) \(request.path)")
        XCTAssertEqual(try JSON.parse(JSONEncoder().encode(capitec)), try JSON.parse(request.body))
    }

    func testARetryOfTheSamePayinReturnsTheExistingOne() async throws {
        let existing = #"{"paymentRequested":{"money":{"amount":12.3,"currencyCode":"ZAR"}},"paymentMethodResponse":{"paymentMethodCode":"CAPITEC_PAY","reference":"R1"}}"#
        let accepted = try await api((409, "[]"), (200, existing)).createPayin(idPayin: "order-1", payin: capitec)
        XCTAssertEqual("R1", accepted.nextStep()?.reference)
        XCTAssertEqual(["POST /payins/order-1", "GET /payins/order-1"], StubAPI.received.map { "\($0.method) \($0.path)" })
    }

    func testARetryWithAnotherMethodIsRefused() async throws {
        do {
            _ = try await api((409, "[]"), (200, #"{"paymentMethodResponse":{"paymentMethodCode":"FNB_DIRECT_EFT"}}"#)).createPayin(idPayin: "order-1", payin: capitec)
            XCTFail("accepted")
        } catch let error as SynqtAPIError {
            XCTAssertEqual(409, error.httpCode)
            XCTAssertEqual(["PAYIN_ALREADY_STARTED"], error.errors.map(\.code))
        }
    }

    func testARefusalKeepsItsCodesButNotWhatThePayerTyped() async throws {
        do {
            _ = try await api((406, #"[{"code":"INVALID_PHONE_NUMBER","attrCode":"phoneNumber","attrValue":"0821234567","description":"bad"}]"#))
                .createPayin(idPayin: "order-1", payin: capitec)
            XCTFail("accepted")
        } catch let error as SynqtAPIError {
            XCTAssertEqual([.init(code: "INVALID_PHONE_NUMBER", field: "phoneNumber", description: "bad")], error.errors)
            XCTAssertFalse("\(error)".contains("0821234567"))
        }
    }

    func testCreatePayinChecksBeforeSending() async throws {
        let api = api((201, "{}"))
        let insecure = Payin(paymentRequested: PaymentRequested(money: money), paymentMethod: .capitecPay(.init(phoneNumber: "0821234567")), returnUrl: "http://x.io/return")
        for (id, payin) in [("../x", capitec), ("order-1", insecure)] {
            do {
                _ = try await api.createPayin(idPayin: id, payin: payin)
                XCTFail(id)
            } catch is SynqtArgumentError {}
        }
        XCTAssertTrue(StubAPI.received.isEmpty)
    }

    func testRandUsesTheHouseFormat() {
        XCTAssertEqual("R1,250.00", formatMoney(1250, "ZAR"))
        XCTAssertEqual("USD 1,250.50", formatMoney(Decimal(string: "1250.5")!, "USD"))
        XCTAssertEqual("BTC 0.00012345", formatMoney(Decimal(string: "0.00012345")!, "BTC")) // real decimals are never rounded away
    }

    func testErrorsKeepCodeAndFieldButNeverTheValue() {
        let body = Data(#"[{"code":"INVALID_ACCOUNT_NUMBER","description":"Bad account","attrCode":"account.accountNumber","attrValue":"1234567890"}]"#.utf8)
        let error = SynqtAPIError(httpCode: 406, errors: parseErrors(body))
        XCTAssertEqual([.init(code: "INVALID_ACCOUNT_NUMBER", field: "account.accountNumber", description: "Bad account")], error.errors)
        XCTAssertEqual("SYNQT HTTP 406: INVALID_ACCOUNT_NUMBER (account.accountNumber)", error.description)
        XCTAssertFalse("\(error)".contains("1234567890"))
        XCTAssertEqual([PayinError("account.accountNumber", "Check the account number and try again. (INVALID_ACCOUNT_NUMBER)")], payinErrors(error))
        // A code with no payer wording never shows SYNQT's description, which is written for the merchant.
        let unworded = payinErrors(SynqtAPIError(httpCode: 406, errors: [
            .init(code: "EMAIL_INVALID", field: "emailAddress", description: "Bad email"),
            .init(code: "NEW_CODE", field: nil, description: "Bad thing"),
        ]))
        XCTAssertEqual([PayinError("emailAddress", "Check this field (EMAIL_INVALID)"),
                        PayinError(nil, "Your payment could not be completed. Please try again, or choose another payment method. (NEW_CODE)")], unworded)
        XCTAssertFalse(unworded.contains { $0.text.contains("Bad") })
    }

    func testSheetMessagesForOtherErrors() {
        XCTAssertEqual([PayinError(nil, "SYNQT could not process this payment (SYSTEM). Try again later or choose another method.")],
                       payinErrors(SynqtAPIError(httpCode: 406, errors: parseErrors(Data(#"{"code":"SYSTEM","description":null}"#.utf8)))))
        XCTAssertEqual([], parseErrors(Data("<html>".utf8)))
        XCTAssertEqual(["The payment could not be created (HTTP 406)."], payinErrors(SynqtAPIError(httpCode: 406, errors: [])).map(\.text))
        XCTAssertEqual("SYNQT HTTP 401", SynqtAPIError(httpCode: 401, errors: []).description)
        XCTAssertEqual(["Something went wrong while processing your payment. Please try again, or choose another payment method. If it keeps happening, contact the merchant. (PAYMENT_PROCESS_ERROR)"],
                       payinErrors(SynqtAPIError(httpCode: 406, errors: [.init(code: "PAYMENT_PROCESS_ERROR", field: nil, description: "For the merchant")])).map(\.text))
        XCTAssertEqual(["Your payment could not be completed. Please try again, or choose another payment method. (NEW_CODE)"],
                       payinErrors(SynqtAPIError(httpCode: 406, errors: [.init(code: "NEW_CODE", field: nil, description: nil)])).map(\.text))
    }

    func testEveryKeyTheSheetUsesHasEnglishText() throws {
        // Keys passed to text("…") in the sources, so a typo shows up here rather than as a raw key in front of a payer.
        let sources = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent("../../Sources/SynqtSDK")
        let files = try FileManager.default.subpathsOfDirectory(atPath: sources.path).filter { $0.hasSuffix(".swift") }
        let keys = try files.flatMap { file -> [String] in
            let source = try String(contentsOf: sources.appendingPathComponent(file), encoding: .utf8)
            return source.matches(#"text\("(synqt_[a-z0-9_]+)""#)
        }
        XCTAssertFalse(keys.isEmpty)
        XCTAssertEqual([], Set(keys).filter { text($0) == $0 }.sorted())
    }

    @MainActor
    func testSheetErrorsAreReadOutToVoiceOver() {
        let form = methodForms.first { $0.code == "CAPITEC_PAY" }!
        let summary = PaymentSummary(amount: "R1.00", merchant: nil, method: "Capitec Pay", reference: "o-1")
        let model = PaymentSheetModel(form: form, prefill: [:], operators: [], summary: summary) { _ in throw URLError(.notConnectedToInternet) }
        var said = [String]()
        model.announce = { said.append($0) }
        var started = 0
        model.onPaymentStarted = { started += 1 }
        model.pay()
        XCTAssertEqual(["Account number: Required\nLast name: Required"], said)
        XCTAssertEqual(0, started) // nothing went to SYNQT
    }

    @MainActor
    func testPaymentStartedWhenTheDetailsGoToSynqt() {
        let form = methodForms.first { $0.code == "ZAPPER_QR" }!
        let summary = PaymentSummary(amount: "R1.00", merchant: nil, method: "Zapper", reference: "o-1")
        let all = ["emailAddress": "test@example.com", "customerName.firstName": "Jane", "customerName.lastName": "Doe"]
        let model = PaymentSheetModel(form: form, prefill: all, operators: [], summary: summary) { _ in throw URLError(.notConnectedToInternet) }
        var started = 0
        model.onPaymentStarted = { started += 1 }
        model.start() // everything mandatory is prefilled, so it pays straight away
        XCTAssertEqual(1, started)
    }

    @MainActor
    func testInvalidPrefillIsShownWithItsError() {
        let form = MethodForm("TEST", "Test", [
            FormField("emailAddress", "Email", .email, required: true),
            FormField("customerName.lastName", "Last name", .text, required: true),
            FormField("bank", "Bank", .choice, required: false, invalid: "synqt_sheet_required", options: [("A", "Bank A")]),
        ]) { _ in throw URLError(.badURL) }
        let summary = PaymentSummary(amount: "R1.00", merchant: nil, method: "Test", reference: "o-1")
        let model = PaymentSheetModel(form: form, prefill: ["emailAddress": "not-an-email", "customerName.lastName": "Doe", "bank": "Z"],
                                      operators: [], summary: summary) { _ in throw URLError(.badURL) }
        XCTAssertFalse(model.visible("customerName.lastName")) // valid, so hidden
        XCTAssertTrue(model.visible("emailAddress"))
        XCTAssertEqual(text("synqt_sheet_check_field"), model.marks["emailAddress"])
        XCTAssertTrue(model.visible("bank")) // not one of its options: shown, empty, with the error
        XCTAssertEqual("", model.values["bank"])
        XCTAssertEqual(text("synqt_sheet_check_field"), model.marks["bank"])
        XCTAssertNil(model.marks["customerName.lastName"])
    }

    func testOrbitDotsFollowTheLottieKeyframes() {
        XCTAssertEqual(0, ease(0), accuracy: 0.001)
        XCTAssertEqual(0.5, ease(0.5), accuracy: 0.001)
        XCTAssertEqual(1, ease(1), accuracy: 0.001)
        XCTAssertEqual(0, orbitDot(0).angle, accuracy: 0.001) // magenta starts at the top
        XCTAssertEqual(40, orbitDot(0).distance, accuracy: 0.001)
        XCTAssertEqual(360, orbitDot(96.05).angle, accuracy: 0.01) // one full turn
        XCTAssertEqual(0, orbitDot(130).distance, accuracy: 0.001) // resting in the hub
        XCTAssertEqual(40, orbitDot(174).distance, accuracy: 0.001) // back out, ready to loop
        // Aqua runs 7.2 frames behind; the file starts it at -35.51 on the y axis.
        XCTAssertEqual(35.51, orbitDot(-orbitDelay).distance, accuracy: 0.05)
    }

    func testReturnURLMatchesItsPathOnly() {
        let back = URL(string: "https://x.io/return")!
        XCTAssertTrue(isReturn(URL(string: "https://x.io/return?idPayin=1")!, to: back))
        XCTAssertFalse(isReturn(URL(string: "https://x.io/returned")!, to: back))
        XCTAssertFalse(isReturn(URL(string: "https://evil.io/return")!, to: back))
    }

    func testIconsParse() {
        for icon in SynqtIcon.allCases { XCTAssertFalse(icon.path.isEmpty, "\(icon)") }
        XCTAssertEqual(CGRect(x: 0, y: 0, width: 10, height: 10), svgPath("M0,0 h10 v10 Z").boundingRect)
    }
}

private extension String {
    func matches(_ pattern: String) -> [String] {
        let re = try! NSRegularExpression(pattern: pattern)
        return re.matches(in: self, range: NSRange(startIndex..., in: self)).compactMap { Range($0.range(at: 1), in: self).map { String(self[$0]) } }
    }
}

/// Answers each request with the next of `answers` (the last one repeats) and keeps what it received.
private final class StubAPI: URLProtocol {
    nonisolated(unsafe) static var answers: [(Int, String)] = []
    nonisolated(unsafe) static var received: [(method: String, path: String, body: Data)] = []

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        // URLSession hands a URLProtocol the body as a stream.
        var body = Data()
        if let stream = request.httpBodyStream {
            stream.open()
            var buffer = [UInt8](repeating: 0, count: 4096)
            while stream.hasBytesAvailable, case let count = stream.read(&buffer, maxLength: buffer.count), count > 0 { body.append(buffer, count: count) }
            stream.close()
        }
        let (status, answer) = Self.answers[min(Self.received.count, Self.answers.count - 1)]
        Self.received.append((request.httpMethod ?? "", request.url?.path ?? "", request.httpBody ?? body))
        client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(answer.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
