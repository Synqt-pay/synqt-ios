import XCTest
@testable import SynqtSDK

/// The same inputs, checked the same way, in every SYNQT SDK. Generated: add cases to the shared table, not here.
final class FieldCasesTests: XCTestCase {
    func testEverySdkChecksTheseFieldsTheSameWay() throws {
        let cases: [(code: String, path: String, value: String, want: String?)] = [
            ("CAPITEC_PAY", "said", "0000000000000", nil),
            ("CAPITEC_PAY", "said", "12345", "Enter 13 digits"),
            ("CAPITEC_PAY", "account.accountNumber", "1234567890", nil),
            ("CAPITEC_PAY", "account.accountNumber", "12345678ab", "Enter 10 digits"),
            ("CAPITEC_PAY", "emailAddress", "test@example.com", nil),
            ("CAPITEC_PAY", "emailAddress", "nope", "Enter a valid email address"),
            ("CAPITEC_PAY", "phoneNumber", "0821234567", nil),
            ("CAPITEC_PAY", "phoneNumber", "821234567", "Enter up to 12 characters, starting with 0"),
            ("CAPITEC_PAY", "customerName.lastName", "", "Required"),
            ("CAPITEC_PAY", "customerName.lastName", "Doe", nil),
            ("UPIID", "upiId", "name@bank", nil),
            ("UPIID", "upiId", "namebank", "Enter a UPI ID like name@bank"),
            ("FNB_DIRECT_EFT", "passportNumber", "A1234567", nil),
            ("FNB_DIRECT_EFT", "passportNumber", "1234", "Enter a letter followed by 7 or 8 numbers"),
            ("PIXQR", "taxId", "12345678901234", nil),
            ("PIXQR", "taxId", "123", "Enter your 14-character CPF or CNPJ"),
            ("OTT_VOUCHER", "voucherPin", "123456789012", nil),
        ]
        for testCase in cases {
            let form = try XCTUnwrap(methodForms.first { $0.code == testCase.code }, testCase.code)
            let field = try XCTUnwrap(form.fields.first { $0.path == testCase.path }, "\(testCase.code) \(testCase.path)")
            XCTAssertEqual(testCase.want, problem(field, [testCase.path: testCase.value])?.text, "\(testCase.code) \(testCase.path) \"\(testCase.value)\"")
        }
    }
}
