import XCTest
@testable import SynqtSDK

final class CheckOnLeaveTests: XCTestCase {
    @MainActor
    func testAnEditedFieldIsCheckedOnLeavingItAndAnUntouchedOneWaitsForPay() throws {
        let form = try XCTUnwrap(methodForms.first { $0.code == "ZAPPER_QR" })
        let model = PaymentSheetModel(form: form, prefill: [:], operators: [],
                                      summary: PaymentSummary(amount: "R1.00", merchant: nil, method: "Zapper", reference: "o-1")) { _ in throw URLError(.notConnectedToInternet) }
        let email = try XCTUnwrap(model.inputs.first { $0.path == "emailAddress" })
        model.focus("emailAddress", true)
        model.binding(email).wrappedValue = "not-an-email"
        XCTAssertNil(model.marks["emailAddress"]) // not while typing the first time
        model.focus("emailAddress", false)
        XCTAssertNotNil(model.marks["emailAddress"])
        model.focus("customerName.firstName", true)
        model.focus("customerName.firstName", false)
        XCTAssertNil(model.marks["customerName.firstName"]) // untouched: "Required" only after Pay
        model.binding(email).wrappedValue = "test@example.com"
        XCTAssertNil(model.marks["emailAddress"]) // a field showing an error is rechecked as the payer types
    }
}
