import SwiftUI
import XCTest
@_spi(SynqtAddon) @testable import SynqtSDK

final class AddonTests: XCTestCase {
    private struct Method: SheetMethod {
        let code: String
        let name = "Test add-on"
        let secure = false
        func section(checkout: PayinCheckout, prefill: [String: String]) -> any MethodSection { fatalError("not drawn in unit tests") }
    }

    func testAddedMethodIsOfferedAndNamedOnce() {
        Synqt.addMethod(Method(code: "TEST_ADDON"))
        Synqt.addMethod(Method(code: "TEST_ADDON"))
        XCTAssertEqual(1, Synqt.directPaymentMethods.filter { $0.code == "TEST_ADDON" }.count)
        XCTAssertEqual("Test add-on", DirectPaymentMethod(code: "TEST_ADDON").name)
        XCTAssertFalse(Synqt.directPaymentMethods.contains { $0.code == "CARD" })
    }

    func testThreeDSecureRedirectBecomesARedirect() throws {
        let json = #"{"paymentMethodResponse":{"paymentMethodCode":"CARD","userInteraction":{"type":"REDIRECT","url":"https://acs.example/3ds"}}}"#
        XCTAssertEqual(Redirection(method: "GET", url: "https://acs.example/3ds", data: nil),
                       try JSONDecoder().decode(PayinAcceptedResponse.self, from: Data(json.utf8)).redirect())
    }

    /// A stand-in section: one field, refused or not.
    @MainActor
    private final class Section: MethodSection {
        var problems: [(label: String, message: String)] = []
        var shown: [String: String] = [:]
        var cleared = false
        var view: AnyView { AnyView(EmptyView()) }
        func check() -> [(label: String, message: String)] { problems }
        func paymentMethod() async throws -> JSON { .object(["paymentMethodCode": .string("TEST_ADDON")]) }
        func showError(attr: String, message: String) -> String? {
            guard attr == "test.field" else { return nil }
            shown[attr] = message
            return "Test field"
        }
        func clear() { cleared = true }
    }

    @MainActor
    func testSheetSendsTheSectionsMethodAndRoutesSynqtsFieldErrorsToIt() async {
        let section = Section()
        var sent: [PaymentMethodPayin] = []
        let form = MethodForm("TEST_ADDON", "Test add-on", []) { _ in throw SynqtArgumentError("built by the add-on") }
        let addon = SheetAddon(section: section, secure: false)
        let model = PaymentSheetModel(form: form, prefill: [:], operators: [], summary: PaymentSummary(amount: "R1.00", merchant: nil, method: "Test", reference: "o-1"),
                                      addon: addon) { method in
            sent.append(method)
            throw SynqtAPIError(httpCode: 406, errors: [.init(code: "INVALID_VALUE", field: "test.field", description: nil)])
        }
        XCTAssertNotEqual(text("synqt_sheet_intro_nothing_to_enter"), model.intro)
        section.problems = [("Test field", "Required")]
        model.pay()
        XCTAssertTrue(sent.isEmpty) // its own check failed
        section.problems = []
        model.pay()
        while model.processing { await Task.yield() }
        XCTAssertEqual([.addon(.init(paymentMethodCode: "TEST_ADDON", json: .object(["paymentMethodCode": .string("TEST_ADDON")])))], sent)
        XCTAssertNotNil(section.shown["test.field"])
        XCTAssertNil(model.banner)
        model.close()
        XCTAssertTrue(section.cleared)
    }
}
