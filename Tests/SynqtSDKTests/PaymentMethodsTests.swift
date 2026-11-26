import XCTest
@_spi(SynqtAddon) @testable import SynqtSDK

final class PaymentMethodsTests: XCTestCase {

    private func json(_ value: some Encodable) throws -> JSON { try JSON.parse(JSONEncoder().encode(value)) }

    private func decode(_ body: String) throws -> PaymentMethodResponsePayin { try JSONDecoder().decode(PaymentMethodResponsePayin.self, from: Data(body.utf8)) }

    private func accepted(_ body: String) throws -> PayinAcceptedResponse { try JSONDecoder().decode(PayinAcceptedResponse.self, from: Data(body.utf8)) }

    /// The method response of an accepted payin.
    private func method(_ body: String) throws -> PaymentMethodResponsePayin {
        guard case .methodResponse(let accepted) = try accepted(body), let method = accepted.paymentMethodResponse else { throw URLError(.cannotParseResponse) }
        return method
    }

    func testRequestWritesCodeAndOnlySetFields() throws {
        let encoded = try json(PaymentMethodPayin.capitecPay(.init(phoneNumber: "0821234567", customerName: .init(firstName: "Jane", lastName: "Doe"))))
        XCTAssertEqual("CAPITEC_PAY", encoded["paymentMethodCode"]?.text)
        XCTAssertEqual("0821234567", encoded["phoneNumber"]?.text)
        XCTAssertEqual("Doe", encoded["customerName"]?["lastName"]?.text)
        XCTAssertNil(encoded["said"])
        XCTAssertNil(encoded["customerName"]?["middleName"])
    }

    func testMethodsWithNoFieldsStillSendTheirCode() throws {
        let encoded = try json(PaymentMethodPayin.momoPay(.init()))
        XCTAssertEqual(["paymentMethodCode": .string("MOMOPAY")], encoded.fields)
    }

    func testSharedAccountIsCheckedAgainstEachMethodsOwnFields() throws {
        let missing = PaymentMethodPayin.pse(.init(account: .init(), emailAddress: "a@b.co", phoneNumber: "+27821234567"))
        XCTAssertThrowsError(try missing.validate()) { XCTAssertEqual("PaymentMethodPayin.PseMethod needs account.accountName", ($0 as? SynqtArgumentError)?.message) }
        let extra = PaymentMethodPayin.pse(.init(account: .init(accountName: "A Payer", accountNumber: "1"), emailAddress: "a@b.co", phoneNumber: "+27821234567"))
        XCTAssertThrowsError(try extra.validate()) { XCTAssertEqual("PaymentMethodPayin.PseMethod does not take account.accountNumber", ($0 as? SynqtArgumentError)?.message) }
        // The same type serves a method that needs only the number.
        let capitec = PaymentMethodPayin.capitecPay(.init(account: .init(accountNumber: "123"), phoneNumber: "0821234567"))
        XCTAssertNoThrow(try capitec.validate())
        let encoded = try json(capitec)
        XCTAssertEqual("123", encoded["account"]?["accountNumber"]?.text)
        XCTAssertNil(encoded["account"]?["accountName"])
    }

    func testResponseAccountsShareOneType() throws {
        guard case .absaPay(let absa) = try decode(#"{"paymentMethodCode":"ABSA_PAY","accountCustomer":{"accountName":"A","accountNumber":"1"}}"#),
              case .pse(let pse) = try decode(#"{"paymentMethodCode":"PSE","accountCustomer":{"accountName":"B"}}"#) else { return XCTFail() }
        XCTAssertEqual("1", absa.accountCustomer?.accountNumber)
        XCTAssertEqual("B", pse.accountCustomer?.accountName)
        XCTAssertNil(pse.accountCustomer?.accountNumber)
    }

    func testCardRequestHasNoRawCardField() throws {
        let encoded = try json(PaymentMethodPayin.card(.init(card: .init(cardDataVault: .init(vaultToken: "vt_1")))))
        XCTAssertEqual("vt_1", encoded["card"]?["cardDataVault"]?["vaultToken"]?.text)
        XCTAssertNil(encoded["card"]?["cardDataRaw"])
    }

    func testParsesKnownResponseWithExactAmounts() throws {
        guard case .capitecPay(let response) = try decode(#"{"paymentMethodCode":"CAPITEC_PAY","idPayin":"o-1","reference":"REF1","money":{"amount":100.10,"currencyCode":"ZAR"}}"#)
        else { return XCTFail() }
        XCTAssertEqual("REF1", response.reference)
        XCTAssertEqual(Decimal(string: "100.1"), response.money?.amount)
        XCTAssertNil(response.phoneNumber)
    }

    func testARetryMustBeTheSameMethodAsTheExistingPayin() throws {
        let existing = Data(#"{"paymentMethodResponse":{"paymentMethodCode":"CAPITEC_PAY"}}"#.utf8)
        try requireSameMethod(existing, "CAPITEC_PAY") // a real retry passes
        try requireSameMethod(Data(#"{"redirectTo":{"method":"GET","url":"https://example.com"}}"#.utf8), "FNB_DIRECT_EFT") // nothing to compare
        XCTAssertThrowsError(try requireSameMethod(existing, "FNB_DIRECT_EFT")) { error in
            let apiError = error as! SynqtAPIError
            XCTAssertEqual(409, apiError.httpCode)
            XCTAssertEqual("This payin was already started with CAPITEC_PAY. Start a new payin to pay another way.", apiError.errors[0].description)
            XCTAssertEqual(["This payment was already started with another payment method. Start a new payment to pay another way."], payinErrors(apiError).map(\.text))
        }
    }

    func testZapperInstructionsCarryTheNextStep() throws {
        let method = try method(#"""
            {"paymentMethodResponse":{"paymentMethodCode":"ZAPPER_QR","qrCode":"https://example.com/qr.png",
               "qrRawData":"https://example.com/pay?qr=1","zapperQrDeepLink":"https://example.com/pay?qr=1","reference":"",
               "expireAt":"2026-10-27T15:15:49.725253752Z"}}
            """#)
        guard case .zapperQr = method else { return XCTFail("\(method)") }
        let next = method.nextStep()
        XCTAssertEqual(NextStep(appLink: "https://example.com/pay?qr=1", qrCodeImageURL: "https://example.com/qr.png", qrCodeData: "https://example.com/pay?qr=1",
                                expiresAt: "2026-10-27T15:15:49.725253752Z"), next) // the empty reference is left out
    }

    func testOfflineInstructionsCarryTheAccountToPayInto() throws {
        let next = try method(#"""
            {"paymentMethodResponse":{"paymentMethodCode":"OFFLINE","reference":"REF123",
               "account":{"accountName":"Test Payee","accountNumber":"0000000000","bankName":"Test Bank","bankCode":"000000"},
               "accountCustomer":{"accountName":"Test Payer"}}}
            """#).nextStep()
        XCTAssertEqual("Test Payee", next.payInto?.accountName)
        XCTAssertEqual("000000", next.payInto?.bankCode)
        XCTAssertEqual("REF123", next.reference)
        // Other methods' `account` is not shown as somewhere to pay.
        XCTAssertNil(try method(#"{"paymentMethodResponse":{"paymentMethodCode":"PAYSHAP","account":{"accountNumber":"0000000000"}}}"#).nextStep().payInto)
    }

    func testAppLinksFallBackToTheAppsOwnScheme() {
        XCTAssertEqual(["https://pos.snapscan.io/qr/abc?id=1", "snapscan://pos.snapscan.io/qr/abc?id=1"], appLinks("https://pos.snapscan.io/qr/abc?id=1", "snapscan"))
        XCTAssertEqual(["https://www.zapper.com/payWithZapper?qr=1"], appLinks("https://www.zapper.com/payWithZapper?qr=1", nil))
    }

    func testTimeLeftCountsDownToTheExpiry() {
        let now = ISO8601DateFormatter().date(from: "2026-10-27T13:16:32Z")!
        XCTAssertEqual("01:59:17", timeLeft("2026-10-27T15:15:49.725253752Z", now))
        XCTAssertEqual("", timeLeft("2026-10-27T13:00:00Z", now))
        XCTAssertNil(timeLeft("not a time", now))
    }

    func testFailureReasonsHaveAPayerMessage() {
        let reasons = { (code: String?) in FailureReasons(failedAt: nil, failureReasonCode: code, message: nil) }
        XCTAssertTrue(reasons("PAYMENT_PROCESS_ERROR").payerMessage.hasPrefix("Something went wrong while processing your payment."))
        XCTAssertEqual("Your payment could not be completed. Please try again, or choose another payment method.", reasons("NEW_CODE").payerMessage)
        XCTAssertEqual(reasons("NEW_CODE").payerMessage, reasons(nil).payerMessage)
    }

    func testUnknownOrMalformedMethodDoesNotThrow() throws {
        XCTAssertEqual(.unknown(paymentMethodCode: "NEW_METHOD", json: Data(#"{"paymentMethodCode":"NEW_METHOD","x":1}"#.utf8)),
                       try decode(#"{"paymentMethodCode":"NEW_METHOD","x":1}"#))
        // A field of an unexpected type must not turn a created payin into an error; its next step still reads.
        let method = try method(#"{"paymentMethodResponse":{"paymentMethodCode":"PAYSHAP","reference":"R9","money":"oops"}}"#)
        guard case .unknown(paymentMethodCode: "PAYSHAP", _) = method else { return XCTFail("\(method)") }
        XCTAssertEqual("R9", method.nextStep().reference)
    }

    func testInstructionsExposeTypedMethod() throws {
        guard case .payShap(let payShap) = try method(#"{"paymentMethodResponse":{"paymentMethodCode":"PAYSHAP","reference":"R9"}}"#)
        else { return XCTFail() }
        XCTAssertEqual("R9", payShap.reference)
    }
}
