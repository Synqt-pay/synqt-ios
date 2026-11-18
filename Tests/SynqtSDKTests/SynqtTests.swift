import XCTest
@_spi(SynqtAddon) @testable import SynqtSDK

final class SynqtTests: XCTestCase {

    private func payin(_ id: String = "order-1") throws -> Payin {
        try Synqt(.sandbox).payin(token: "a.b+c", payinID: id, money: Money(amount: Decimal(string: "12.30")!, currencyCode: "ZAR"),
                                  returnURL: "https://x.io/return", callbackURL: "https://x.io/cb")
    }

    func testPaymentAppUrlEncodesParams() throws {
        XCTAssertEqual(
            "https://payment.sandbox.synqt.io/?merchantCode=MID&idPayin=order-1&token=a.b%2Bc&amount=12.3" +
                "&currencyCode=ZAR&callbackUrl=https%3A%2F%2Fx.io%2Fcb&returnUrl=https%3A%2F%2Fx.io%2Freturn&emailAddress=a%40b.co",
            try payin().paymentAppURL(merchantCode: "MID", extra: ["emailAddress": "a@b.co"])
        )
    }

    func testPaymentAppOffersAMethodAndEditablePrefill() throws {
        let url = try payin().paymentAppURL(merchantCode: "MID", paymentMethodCode: "CAPITEC_PAY", prefill: ["phoneNumber": "+27821234567"])
        XCTAssertTrue(url.hasSuffix("&paymentMethodCode=CAPITEC_PAY&optionsAvailable=true&phoneNumber=%2B27821234567&allowCustomerDataChange=true"), url)
        XCTAssertFalse(try payin().paymentAppURL(merchantCode: "MID").contains("optionsAvailable"))
    }

    func testRejectsUnsafeId() {
        XCTAssertThrowsError(try payin("../x"))
    }

    func testReturnURLMustBeHttps() {
        let money = Money(amount: 1, currencyCode: "ZAR")
        for bad in ["http://x.io/return", "myapp://return", "x.io/return"] {
            XCTAssertThrowsError(try Synqt(.sandbox).payin(token: "t", payinID: "o-1", money: money, returnURL: bad, callbackURL: "https://x.io/cb"), bad)
        }
    }

    func testParsesRedirect() throws {
        XCTAssertEqual(.redirect(httpMethod: "POST", url: "https://p.io", formData: ["k": "v", "n": "1"]),
                       try parseCreatePayin(Data(#"{"redirectTo":{"method":"POST","url":"https://p.io","data":"{\"k\":\"v\",\"n\":1}"}}"#.utf8)))
    }

    func testParsesStatus() throws {
        let payinStatus = parsePayinStatus(try JSON.parse(Data(#"""
            {"paymentRequested":{"money":{"amount":100.50,"currencyCode":"ZAR"}},"fee":{"amount":2,"currencyCode":"ZAR"},
               "process":{"status":"FAILED","isTest":true,"createdAt":"2026-10-26T10:00:00Z",
                 "failureReasons":{"failureReasonCode":"ENTITY_EXPIRED","message":"Expired","failedAt":"2026-10-26T12:00:00Z"}},
               "paymentMethodResponse":{"paymentMethodCode":"CAPITEC_PAY"}}
            """#.utf8)))
        XCTAssertEqual(.failed, payinStatus.status)
        XCTAssertTrue(payinStatus.status.isFinal && payinStatus.isTest)
        XCTAssertEqual(Money(amount: Decimal(string: "100.5")!, currencyCode: "ZAR"), payinStatus.requested)
        XCTAssertEqual("ENTITY_EXPIRED", payinStatus.failureReason?.code)
        guard case .capitecPay = payinStatus.paymentMethod else { return XCTFail() }
    }

    func testUnknownStatusIsNotFinal() throws {
        let payinStatus = parsePayinStatus(try JSON.parse(Data(#"{"process":{"status":"ON_HOLD"}}"#.utf8)))
        XCTAssertEqual(.unknown, payinStatus.status)
        XCTAssertFalse(payinStatus.status.isFinal)
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
