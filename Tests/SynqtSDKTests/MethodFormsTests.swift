import XCTest
@_spi(SynqtAddon) @testable import SynqtSDK

final class MethodFormsTests: XCTestCase {

    private func form(_ code: String) -> MethodForm { methodForms.first { $0.code == code }! }

    private func pairs(_ errors: [PayinError]) -> [String] { errors.map { "\($0.attr ?? "-")=\($0.text)" } }

    func testEveryMethodExceptCardHasANamedForm() {
        XCTAssertEqual(32, Set(methodForms.map(\.code)).count)
        XCTAssertFalse(methodForms.contains { $0.code == "CARD" })
        XCTAssertEqual("Capitec Pay", text(form("CAPITEC_PAY").name))
    }

    func testEveryStringTheFormsUseHasEnglishText() {
        var keys = [String]()
        for methodForm in methodForms {
            keys.append(methodForm.name)
            for question in methodForm.oneOfs { keys += [question.question] + question.choices.map(\.label) }
            for field in methodForm.fields { keys += [field.label, field.hint, field.placeholder, field.section, field.invalid].compactMap { $0 } + field.options.map(\.label) }
        }
        XCTAssertEqual([String](), keys.filter { text($0) == $0 })
    }

    func testPayersNeverSeeJsonPaths() {
        let paths = methodForms.flatMap(\.fields).map { text($0.label) }.filter { $0.contains(".") || $0.range(of: "^[a-z]+[A-Z]", options: .regularExpression) != nil }
        XCTAssertEqual([], paths)
    }

    func testBlankGroupsAreLeftOutAndFilledOnesBuilt() throws {
        let method = try form("CAPITEC_PAY").build(FormValues(values: [
            "phoneNumber": " 0821234567 ", "account.accountNumber": "", "customerName.lastName": "Doe",
        ]))
        XCTAssertEqual(.capitecPay(.init(phoneNumber: "0821234567", customerName: .init(lastName: "Doe"))), method)
    }

    func testMissingRequiredFieldNamesThePath() {
        XCTAssertThrowsError(try form("CAPITEC_PAY").build(FormValues(values: ["customerName.firstName": "Jane"]))) { error in
            XCTAssertEqual("customerName.lastName", (error as? SynqtArgumentError)?.path)
        }
    }

    func testProblemsUseTheSpecLimitsInPlainWords() {
        let problems = form("CAPITEC_PAY").problems(["said": "12345", "account.accountNumber": "12345678ab", "emailAddress": "nope", "customerName.lastName": "Doe"], [])
        XCTAssertEqual(["emailAddress=Enter a valid email address", "said=Enter 13 digits", "account.accountNumber=Enter 10 digits"], pairs(problems))
    }

    func testASectionWithAMandatoryFieldIsMandatory() {
        let capitec = form("CAPITEC_PAY")
        XCTAssertEqual(["customerName.lastName=Required"], pairs(capitec.problems([:], [])))
        XCTAssertEqual("Your name", text(capitec.fields.first { $0.path == "customerName.lastName" }!.section!))
        // A section with nothing mandatory in it stays optional.
        XCTAssertEqual("Bank account (optional)", text(form("EWALLET").fields.first { $0.path.hasPrefix("account.") }!.section!))
        XCTAssertEqual("account.accountNumber=Required", pairs(form("FNB_DIRECT_EFT").problems([:]).filter { $0.attr == "account.accountNumber" }).first)
    }

    func testOneFieldIsCheckedOnItsOwn() {
        let said = form("CAPITEC_PAY").fields.first { $0.path == "said" }!
        XCTAssertEqual(PayinError("said", "Enter 13 digits"), problem(said, ["said": "12345"]))
        XCTAssertNil(problem(said, ["said": "0000000000000"]))
    }

    func testAbsaPayAsksForOneDetailAndBankAccountIsTheDefault() throws {
        let absa = form("ABSA_PAY")
        let bank = absa.oneOfs[0].choices[0], id = absa.oneOfs[0].choices[1]
        XCTAssertEqual("Bank account", text(bank.label))
        let lastName = "customerName.lastName=Required" // the name is asked for on Absa Pay, though the spec makes it optional
        XCTAssertEqual(["account.accountNumber=Required", lastName], pairs(absa.problems([:])))
        // Picking the ID number makes it the required one, and a stale account number is not checked or sent.
        XCTAssertEqual(["said=Required", lastName], pairs(absa.problems(["account.accountNumber": "x"], [id])))
        XCTAssertTrue(absa.shows("emailAddress", [id]))
        XCTAssertFalse(absa.shows("account.accountNumber", [id]))
        guard case .absaPay(let method) = try absa.build(FormValues(values: ["said": "0000000000000", "customerName.lastName": "Doe"])) else { return XCTFail() }
        XCTAssertEqual("0000000000000", method.said)
        XCTAssertNil(method.account)
    }

    func testPayShapTilesNeedTheirCompanionFields() {
        let payShap = form("PAYSHAP")
        let bank = payShap.oneOfs[0].choices[0], mobile = payShap.oneOfs[0].choices[1]
        let values = ["paymentOperatorCode": "BANK", "customerName.lastName": "Doe"]
        XCTAssertEqual(["account.accountName", "account.accountNumber"], payShap.problems(values, [bank]).map(\.attr))
        XCTAssertEqual(["phoneNumber", "externalProviderCode"], payShap.problems(values, [mobile]).map(\.attr))
        XCTAssertEqual([], payShap.problems(values.merging(["phoneNumber": "000000000000", "externalProviderCode": "X"]) { $1 }, [mobile]))
        XCTAssertEqual(["Mobile number", "Provider"], payShap.fields.filter { mobile.paths.contains($0.path) }.map { text($0.label) })
    }

    func testFnbPayAsksForIdOrPassportWithIdFirst() {
        let fnbPay = form("FNB_DIRECT_EFT")
        let id = fnbPay.oneOfs[0].choices[0], passport = fnbPay.oneOfs[0].choices[1]
        XCTAssertEqual(["South African ID number", "Passport number"], [text(id.label), text(passport.label)])
        XCTAssertEqual(["said=Required"], pairs(fnbPay.problems([:]).filter { $0.attr == "said" }))
        XCTAssertFalse(fnbPay.problems([:], [passport]).contains { $0.attr == "said" })
        XCTAssertEqual(["passportNumber=Required"], pairs(fnbPay.problems([:], [passport]).filter { $0.attr == "passportNumber" }))
    }

    func testPayShapAlsoAsksWhichIdButLeavesItOptional() {
        let payShap = form("PAYSHAP")
        let pay = payShap.oneOfs[0], ids = payShap.oneOfs[1]
        XCTAssertEqual("Which ID do you want to give?", text(ids.question))
        let id = ids.choices[0], passport = ids.choices[1]
        XCTAssertEqual(["South African ID number (optional)", "Passport number (optional)"],
                       ["said", "passportNumber"].map { path in text(payShap.fields.first { $0.path == path }!.label) })
        let chosen = [pay.choices[0], id]
        XCTAssertTrue(payShap.shows("said", chosen))
        XCTAssertFalse(payShap.shows("passportNumber", chosen))
        // Both IDs are optional in the spec, so choosing one does not make it mandatory.
        XCTAssertFalse(payShap.problems([:], chosen).contains { $0.attr == "said" })
        XCTAssertEqual(["passportNumber=Enter a letter followed by 7 or 8 numbers"],
                       pairs(payShap.problems(["passportNumber": "123"], [pay.choices[0], passport]).filter { $0.attr == "passportNumber" }))
    }

    func testOnlyValidPrefilledFieldsCountAsFilledIn() {
        let zapper = form("ZAPPER_QR")
        let prefill = ["emailAddress": "test@example.com", "customerName.firstName": "Jane", "customerName.lastName": "Doe"]
        XCTAssertEqual(["emailAddress", "customerName.firstName", "customerName.lastName"], zapper.filledIn(prefill, prefill, []))
        // A malformed email stays in view so the payer can fix it; a value the payer has since changed is theirs.
        var badEmail = prefill
        badEmail["emailAddress"] = "nope"
        XCTAssertEqual(["customerName.firstName", "customerName.lastName"], zapper.filledIn(badEmail, badEmail, []))
        var changed = prefill
        changed["customerName.firstName"] = "Janet"
        XCTAssertEqual(["emailAddress", "customerName.lastName"], zapper.filledIn(changed, prefill, []))
    }

    func testAPrefilledFirstAndLastNameHideTheOptionalNameFields() {
        let capitec = form("CAPITEC_PAY")
        let names = ["customerName.firstName": "Jane", "customerName.lastName": "Doe"]
        XCTAssertEqual(["customerName.firstName", "customerName.lastName", "customerName.titleBefore", "customerName.middleName", "customerName.titleAfter"],
                       capitec.filledIn(names, names, capitec.defaultChoices))
        // With only the last name, the payer still sees the rest of the name section.
        let last = ["customerName.lastName": "Doe"]
        XCTAssertEqual(["customerName.lastName"], capitec.filledIn(last, last, capitec.defaultChoices))
    }

    func testTheSheetPaysStraightAwayOnlyWhenEveryMandatoryFieldIsFilledIn() {
        let zapper = form("ZAPPER_QR")
        let all = ["emailAddress": "test@example.com", "customerName.firstName": "Jane", "customerName.lastName": "Doe"]
        XCTAssertTrue(zapper.readyToPay(all, zapper.filledIn(all, all, []), []))
        var noEmail = all
        noEmail["emailAddress"] = nil
        XCTAssertFalse(zapper.readyToPay(noEmail, zapper.filledIn(noEmail, noEmail, []), []))
        // Net banking has only optional fields, so the payer still sees its form.
        XCTAssertFalse(form("NETBANKING").readyToPay([:], [], []))
    }

    func testSouthAfricanRulesMakeSpecOptionalFieldsMandatory() {
        XCTAssertEqual(["paymentOperatorCode", "emailAddress", "account.accountName", "account.accountNumber", "account.accountType"],
                       form("ONLINE").fields.filter(\.required).map(\.path))
        XCTAssertTrue(form("OFFLINE").fields.first { $0.path == "paymentOperatorCode" }!.required)
        XCTAssertEqual(["paymentOperatorCode=Required"], pairs(form("OFFLINE").problems([:]).filter { $0.attr == "paymentOperatorCode" }))
    }

    func testCapitecPayAsksForOneDetail() {
        XCTAssertEqual(["Bank account", "Mobile number", "South African ID number"], form("CAPITEC_PAY").oneOfs[0].choices.map { text($0.label) })
    }

    func testEveryFormBuildsAMethodThatPassesItsOwnChecks() throws {
        // Fill every field with something, so a form never builds a method that `createPayin` would then reject.
        for methodForm in methodForms {
            let values = Dictionary(uniqueKeysWithValues: methodForm.fields.map { ($0.path, $0.options.first?.value ?? "x") })
            XCTAssertNoThrow(try methodForm.build(FormValues(values: values)).validate(), methodForm.code)
        }
    }

    func testPaymentOperatorsCarryTheirExternalProviders() throws {
        let op = try JSONDecoder().decode(PaymentOperatorIncoming.self, from: Data(#"""
            {"code":"ZA_BANK","name":"A Bank","externalProviders":{"providers":[{"code":"P1","name":"Provider one"},{"name":"no code"}]}}
            """#.utf8))
        XCTAssertEqual(PaymentOperatorIncoming(code: "ZA_BANK", name: "A Bank", externalProviders: ExternalProviders(providers: [
            ExternalProvider(code: "P1", name: "Provider one"), ExternalProvider(code: nil, name: "no code"),
        ])), op)
        // The sheet skips providers without a code.
        XCTAssertEqual([ExternalProvider(code: "P1", name: "Provider one")], providers([op]))
    }

    func testProvidersListEveryBanksProvidersOnce() {
        // Shaped like Stable's PayShap options: bank codes with providers that repeat across banks.
        let p1 = ExternalProvider(code: "STANDARDBANK", name: "StandardBank")
        let p2 = ExternalProvider(code: "SHYFT", name: "Shyft")
        let p3 = ExternalProvider(code: "CAPITEC", name: "CAPITEC")
        let bank = { (code: String, name: String, providers: [ExternalProvider]) in
            PaymentOperatorIncoming(code: code, name: name, externalProviders: ExternalProviders(providers: providers))
        }
        let banks = [
            bank("ZA_STANDARD", "Standard Bank", [p1, p2]),
            bank("ZA_CAPITEC", "Capitec", [p3, p1]),
            bank("NG_BANK", "Another market", [ExternalProvider(code: "NG_P", name: "x")]),
        ]
        XCTAssertEqual([p1, p2, p3, ExternalProvider(code: "NG_P", name: "x")], providers(banks))
        XCTAssertEqual(.provider, form("PAYSHAP").fields.first { $0.path == "externalProviderCode" }!.kind)
    }

    func testSaMobileNumbersAreUpTo12CharactersStartingWith0() {
        for code in ["PAYSHAP", "CAPITEC_PAY"] {
            let phone = form(code).fields.first { $0.path == "phoneNumber" }!
            XCTAssertNil(problem(phone, ["phoneNumber": "0000000000"])) // 10 digits, the usual SA length
            XCTAssertNil(problem(phone, ["phoneNumber": "000000000000"]))
            XCTAssertEqual("Enter up to 12 characters, starting with 0", problem(phone, ["phoneNumber": "1000000000"])?.text)
            XCTAssertEqual("Enter up to 12 characters, starting with 0", problem(phone, ["phoneNumber": "0000000000000"])?.text)
        }
    }

    func testAccountNamesTakeLettersFromAnyLanguage() {
        let name = form("CAPITEC_PAY").fields.first { $0.path == "account.accountName" }!
        XCTAssertNil(problem(name, ["account.accountName": "Zoë O'Neill-Nkosi"]))
        XCTAssertEqual("Use letters, numbers, spaces and common punctuation only", problem(name, ["account.accountName": "A <b>"])?.text)
    }

    func testPaymentOptionsCarryOperatorsAndPayerFacingNames() throws {
        let options = try XCTUnwrap(JSONDecoder().decode(AvailablePayinOptionList.self, from: Data(#"""
            {"data":[{"paymentMethodCode":"FPX","paymentOperators":[{"code":"MBB","name":"Maybank"},{"code":"X"}]},
               {"paymentMethodCode":"BRAND_NEW","segmentCode":"S1"}]}
            """#.utf8)).data)
        XCTAssertEqual(AvailablePayinOption(paymentMethodCode: "FPX", paymentOperators: [
            PaymentOperatorIncoming(code: "MBB", name: "Maybank", externalProviders: nil), PaymentOperatorIncoming(code: "X", name: nil, externalProviders: nil),
        ], segmentCode: nil), options[0])
        XCTAssertEqual(AvailablePayinOption(paymentMethodCode: "BRAND_NEW", paymentOperators: nil, segmentCode: "S1"), options[1])
        XCTAssertEqual("FPX online banking", options[0].name)
        XCTAssertNil(options[1].name) // the sheet cannot show it, so it has no payer-facing name
    }
}
