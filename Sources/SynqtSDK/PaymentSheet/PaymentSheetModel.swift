import SwiftUI

/// What the sheet's order summary shows. `merchant` is nil when the token cannot read GET /merchant-info.
struct PaymentSummary: Equatable {
    var amount: String
    let merchant: String?
    let method: String
    let reference: String
}

/// An add-on's method in the sheet: its fields, whether they are secret, and how to send what it builds.
struct SheetAddon {
    let section: any MethodSection
    let secure: Bool
    let submit: (JSON) async throws -> CreatePayinResult
}

/**
 The payment sheet's state and behaviour, apart from the platform: Pay checks the values, builds the typed method and
 hands it to `submit`; a processing state covers the form meanwhile, and every error comes back next to its field.
 The presenter supplies how to open links, copy text and close the sheet.
 */
@MainActor
final class PaymentSheetModel: ObservableObject {
    let form: MethodForm
    let summary: PaymentSummary
    let methodName: String
    private let prefill: [String: String]
    @Published private(set) var operators: [PaymentOperator]
    /// SYNQT's list of banks and providers could not be loaded, so a mandatory bank or provider field can't be filled in.
    @Published private(set) var banksFailed: Bool
    @Published private(set) var loadingBanks = false
    private let submit: (PaymentMethod) async throws -> CreatePayinResult
    /// An add-on method's own fields, which it draws, checks and builds itself; nil for built-in methods.
    let addon: SheetAddon?
    /// The add-on's fields' scroll target.
    static let addonID = "addon"

    /// The fields the payer could fill in: an optional bank with no list from SYNQT has nothing to choose, so it goes.
    let inputs: [FormField]
    @Published var values: [String: String]
    /// The tile picked for each question: the one the app prefilled, else the first.
    @Published private(set) var chosen: [Choice]
    @Published private(set) var marks: [String: String] = [:]
    @Published private(set) var banner: String?
    /// Fields the app prefilled with a value that passes its checks: hidden, but still sent. Shown again if SYNQT refuses it.
    @Published private(set) var filledIn: Set<String> = []
    @Published private(set) var processing = false
    @Published private(set) var next: NextStep?
    @Published private(set) var appProblem: String?
    @Published private(set) var toast: String?
    /// The field to scroll to and focus, with a counter so asking for the same one twice still moves there.
    @Published private(set) var focusRequest: (path: String, count: Int)?

    // Fields are checked as the payer goes, but a field they have not typed in only shows "Required" after Pay.
    private var edited: Set<String> = []
    private var invalid: Set<String> = [] // showing a problem found here, rechecked on every change
    private var refused: Set<String> = [] // showing SYNQT's error, kept until the payer edits that field
    private var focused: String?
    /// The payin result once SYNQT accepted it, returned however the payer closes the sheet afterwards.
    private(set) var accepted: CreatePayinResult?
    private var openedApp = false
    private var finished = false

    // Set by the presenter.
    var onFinish: (CreatePayinResult?) -> Void = { _ in }
    var onPaymentStarted: () -> Void = {}
    /// Opens a link in the method's own app if it is installed; false if nothing took it.
    var openInApp: (String) async -> Bool = { _ in false }
    /// Opens a link wherever the system sends it (the browser if no app claims it); false if nothing can.
    var openLink: (String) async -> Bool = { _ in false }
    var copy: (String) -> Void = { _ in }
    /// Reads text out to VoiceOver users without moving their focus.
    var announce: (String) -> Void = { _ in }
    /// The height the whole sheet needs to show everything without scrolling, for a presenter that can size to it (iPad).
    var fitHeight: (CGFloat) -> Void = { _ in }
    /// Loads the banks and providers again, as the presenter first did; nil if they still could not be loaded.
    var reloadOperators: () async -> [PaymentOperator]? = { nil }

    /// `operators` is nil when SYNQT's list could not be loaded.
    init(form: MethodForm, prefill: [String: String], operators: [PaymentOperator]?, summary: PaymentSummary, addon: SheetAddon? = nil,
         submit: @escaping (PaymentMethod) async throws -> CreatePayinResult) {
        self.form = form
        self.addon = addon
        self.prefill = prefill
        banksFailed = operators == nil
        let operators = operators ?? []
        self.operators = operators
        self.summary = summary
        self.submit = submit
        methodName = text(form.name)
        inputs = form.fields.filter { !($0.kind == .operator && operators.isEmpty && !$0.required) }
        // A dropdown keeps a prefill only if it is one of its options.
        var values = [String: String]()
        let fieldOptions = Dictionary(uniqueKeysWithValues: form.fields.map { field in (field.path, Self.options(field, operators)) })
        for field in inputs {
            let value = prefill[field.path] ?? ""
            values[field.path] = fieldOptions[field.path]??.contains { $0.value == value } == false ? "" : value
        }
        self.values = values
        chosen = form.oneOfs.map { question in question.choices.first { !(prefill[$0.paths[0]] ?? "").isBlank } ?? question.choices[0] }
        for (questionIndex, choice) in chosen.enumerated() { clearOthers(questionIndex, choice) }
        filledIn = Set(form.filledIn(effectiveValues(), prefill, chosen))
        // A prefill left in view fails its checks, so it shows its error from the start; a dropdown's unlisted one was cleared above.
        for field in inputs where form.shows(field.path, chosen) && !filledIn.contains(field.path) && !(prefill[field.path] ?? "").isBlank {
            if values[field.path] == prefill[field.path] { check(field.path); continue }
            marks[field.path] = text("synqt_sheet_check_field") // field.invalid is about typing, not picking
            invalid.insert(field.path)
        }
    }

    /// Everything mandatory came from the app, so pay straight away; the processing view covers the form, and any
    /// refusal brings the form back with the error.
    func start() {
        if form.readyToPay(effectiveValues(), Array(filledIn), chosen) { pay() }
    }

    /// Values as they are checked and sent: fields of tiles the payer did not pick read as blank.
    func effectiveValues() -> [String: String] {
        Dictionary(uniqueKeysWithValues: inputs.map { ($0.path, form.shows($0.path, chosen) ? values[$0.path] ?? "" : "") })
    }

    /// A mandatory bank or provider field shown as "couldn't load" with Try again, as the payer can't fill it in. An
    /// optional one stays as it was without a list: a bank field is hidden, a provider field takes a typed code.
    func banksMissing(_ field: FormField) -> Bool { banksFailed && field.required && (field.kind == .operator || field.kind == .provider) }

    /// Try again: loads the banks and providers once more, with the same retries; the fields come back on success.
    func retryBanks() {
        guard banksFailed, !loadingBanks else { return }
        loadingBanks = true
        Task {
            let loaded = await reloadOperators()
            loadingBanks = false
            guard let loaded else { return announce(text("synqt_sheet_banks_failed")) }
            operators = loaded
            banksFailed = false
            for field in inputs where field.kind == .operator || field.kind == .provider { marks[field.path] = nil }
        }
    }

    /// The choices for a dropdown field, with "Choose one" or "No preference" first, or nil for a typed field.
    func options(_ field: FormField) -> [(value: String, label: String)]? {
        guard let choices = Self.options(field, operators) else { return nil }
        // A provider is only asked for when it is needed, so it never offers "No preference".
        let header = text(field.required || field.kind == .provider ? "synqt_sheet_choose_one" : "synqt_sheet_no_preference")
        return [("", header)] + choices
    }

    private static func options(_ field: FormField, _ operators: [PaymentOperator]) -> [(value: String, label: String)]? {
        switch field.kind {
        case .choice: return field.options.map { ($0.value, text($0.label)) }
        case .operator: return operators.isEmpty ? nil : operators.map { ($0.code, $0.name) }
        // Typed when SYNQT lists no providers.
        case .provider: return providers(operators).isEmpty ? nil : providers(operators).map { ($0.code, $0.name) }
        default: return nil
        }
    }

    /// The hint under a field. A bank or provider the payer types (SYNQT listed none) says what to type.
    func hint(_ field: FormField) -> String {
        if options(field) == nil, field.kind == .operator { return text("synqt_sheet_hint_bank_code") }
        if options(field) == nil, field.kind == .provider { return text("synqt_sheet_hint_provider_code") }
        return field.hint.map { text($0) } ?? ""
    }

    func visible(_ path: String) -> Bool { form.shows(path, chosen) && !filledIn.contains(path) }

    /// A tile question is hidden once the app filled in every field of the chosen tile.
    func questionVisible(_ questionIndex: Int) -> Bool {
        !chosen[questionIndex].paths.filter { path in inputs.contains { $0.path == path } }.allSatisfy(filledIn.contains)
    }

    /// Everything filled in by the app: the whole details section goes, leaving the summary and Pay.
    var allFilledIn: Bool { !inputs.isEmpty && !inputs.contains { visible($0.path) } }

    /// Only when there is nothing to enter; otherwise the summary already names the method, so no intro.
    var intro: String? {
        inputs.isEmpty && addon == nil ? text("synqt_sheet_intro_nothing_to_enter") : nil
    }

    func binding(_ field: FormField) -> Binding<String> {
        Binding(get: { self.values[field.path] ?? "" }, set: { newValue in
            // As the Android sheet's length filter: longer input is cut off as it is typed.
            self.values[field.path] = field.maxLength.map { String(newValue.prefix($0)) } ?? newValue
            self.edit(field.path)
        })
    }

    private func edit(_ path: String) {
        edited.insert(path)
        if refused.remove(path) != nil { marks[path] = nil }
        if invalid.contains(path) { check(path) }
    }

    /// Focus moved; the field it left is checked if the payer typed in it.
    func focus(_ path: String, _ isFocused: Bool) {
        if isFocused { focused = path; return }
        guard focused == path else { return }
        focused = nil
        if edited.contains(path), !refused.contains(path) { check(path) }
    }

    private func check(_ path: String) {
        let field = form.fields.first { $0.path == path }!
        let message = problem(field, effectiveValues(), mustFill: chosen.contains { $0.required.contains(path) })?.text
        marks[path] = message
        if message == nil { invalid.remove(path) } else { invalid.insert(path) }
    }

    /// Shows the picked tile's fields. The others are emptied, so a detail the payer switched away from is never sent.
    func choose(_ questionIndex: Int, _ choice: Choice) {
        chosen[questionIndex] = choice
        clearOthers(questionIndex, choice)
    }

    private func clearOthers(_ questionIndex: Int, _ choice: Choice) {
        for path in form.oneOfs[questionIndex].choices.flatMap(\.paths) where !choice.paths.contains(path) && values[path] != nil {
            values[path] = ""
            marks[path] = nil
            edited.remove(path)
            invalid.remove(path)
            refused.remove(path)
            filledIn.remove(path) // emptied, so the payer enters it if they come back to this tile
        }
    }

    func pay() {
        marks = [:]
        invalid = []
        refused = []
        banner = nil
        let values = effectiveValues()
        let problems = form.problems(values, chosen)
        if !problems.isEmpty { return showErrors(problems) }
        if let addon { return pay(addon) }
        let method: PaymentMethod
        do {
            method = try form.build(FormValues(values: values))
        } catch {
            return showErrors([PayinError((error as? SynqtArgumentError)?.path, text("synqt_sheet_required"))])
        }
        setProcessing(true)
        onPaymentStarted()
        Task {
            defer { setProcessing(false) }
            await send { try await self.submit(method) }
        }
    }

    /// An add-on's method: its fields check themselves, then it builds the request only now, so it can do slow work
    /// such as encrypting card details under the processing view.
    private func pay(_ addon: SheetAddon) {
        let problems = addon.section.check()
        if !problems.isEmpty {
            announce(problems.map { text("synqt_sheet_field_error", $0.label, $0.message) }.joined(separator: "\n"))
            focusRequest = (Self.addonID, (focusRequest?.count ?? 0) + 1)
            return
        }
        setProcessing(true)
        Task {
            defer { setProcessing(false) }
            let method: JSON
            do {
                method = try await addon.section.paymentMethod()
            } catch let sectionError as MethodSectionError {
                return showErrors([PayinError(nil, sectionError.payerMessage)])
            } catch {
                return showFailure(error)
            }
            onPaymentStarted()
            await send { try await addon.submit(method) }
        }
    }

    private func send(_ submit: () async throws -> CreatePayinResult) async {
        do {
            let result = try await submit()
            if case .instructions(_, let next) = result, next.appLink != nil || next.qrCodeImageURL != nil || next.payInto != nil {
                accepted = result
                showNextStep(next)
            } else {
                finish(result)
            }
        } catch {
            showFailure(error)
        }
    }

    private func showFailure(_ error: Error) {
        switch error {
        case let apiError as SynqtAPIError: showErrors(payinErrors(apiError), fromSynqt: true)
        case is URLError: showErrors([PayinError(nil, text("synqt_error_unreachable"))])
        default: showErrors([PayinError(nil, text("synqt_failure_general"))])
        }
    }

    /// While the request runs the form, close button included, is covered so the sheet cannot be closed half way through.
    private func setProcessing(_ on: Bool) {
        processing = on
        if on { announce(text("synqt_sheet_processing")) }
    }

    /// Returns the result once, however the sheet is closed.
    func finish(_ result: CreatePayinResult?) {
        guard !finished else { return }
        finished = true
        addon?.section.clear() // what the payer typed doesn't outlive the sheet
        onFinish(result)
    }

    /// Close or Done: the accepted result if SYNQT took the payment, else nil.
    func close() { finish(accepted) }

    /**
     For methods the payer finishes elsewhere: open the method's app on this phone, scan the QR code from another one,
     or (Pay offline) transfer to SYNQT's account from their banking app. The app opens once by itself; coming back
     shows this step, with the button to open it again.
     */
    private func showNextStep(_ step: NextStep) {
        next = step
        guard !openedApp, let link = step.appLink ?? step.qrCodeData else { return }
        openedApp = true
        Task { _ = await openInApp(link) }
    }

    /// Checked again on each tap, as the payer may install the app while the sheet is open.
    func openApp() {
        guard let link = next?.appLink else { return }
        Task {
            if await openInApp(link) { return }
            if let data = next?.qrCodeData, await openInApp(data) { return }
            if !(await openLink(link)) { appProblem = text("synqt_next_no_app", methodName) }
        }
    }

    func copyValue(_ label: String, _ value: String) {
        copy(value)
        let said = text("synqt_next_copied", label)
        toast = said
        announce(said)
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if toast == said { toast = nil }
        }
    }

    /// Errors for a shown field go under it; the rest go in the banner above the Pay button, named by label, not JSON
    /// path. The first field with an error is scrolled to and focused, and VoiceOver reads every error out, as Android's
    /// live regions do.
    private func showErrors(_ errors: [PayinError], fromSynqt: Bool = false) {
        var general = [String]()
        var spoken = [String]()
        var first: String?
        for error in errors {
            if let attr = error.attr, let label = addon?.section.showError(attr: attr, message: error.text) {
                spoken.append(text("synqt_sheet_field_error", label, error.text))
                if first == nil { first = Self.addonID }
                continue
            }
            let path = error.attr.flatMap { attr in form.fields.first { attr == $0.path || attr.hasSuffix("." + $0.path) }?.path }
            if let path, form.shows(path, chosen), let field = inputs.first(where: { $0.path == path }) {
                filledIn.remove(path) // a prefilled value was refused: let the payer correct it
                marks[path] = error.text
                spoken.append(text("synqt_sheet_field_error", text(field.label), error.text))
                if fromSynqt { refused.insert(path) } else { invalid.insert(path) }
                if first == nil { first = path }
            } else if let path, let field = form.fields.first(where: { $0.path == path }) {
                general.append(text("synqt_sheet_field_error", text(field.label), error.text))
            } else {
                general.append(error.text)
            }
        }
        if !general.isEmpty { banner = general.joined(separator: "\n") }
        announce((spoken + general).joined(separator: "\n"))
        if let target = first ?? (general.isEmpty ? nil : "banner") {
            focusRequest = (target, (focusRequest?.count ?? 0) + 1)
        }
    }
}

/// Payer-facing messages for a refused POST /payins.
func payinErrors(_ error: SynqtAPIError) -> [PayinError] {
    let messages = error.errors.map { err -> PayinError in
        if err.code == "SYSTEM" { return PayinError(err.field, text("synqt_error_system")) }
        if err.code == "PAYIN_ALREADY_STARTED" { return PayinError(err.field, text("synqt_error_already_started")) }
        // SYNQT's description is written for the merchant, so a code without payer wording gets ours.
        let message = text(payerMessageKey(err.code) ?? (err.field == nil ? "synqt_failure_general" : "synqt_sheet_check_field"))
        return PayinError(err.field, text("synqt_error_with_code", message, err.code))
    }
    if !messages.isEmpty { return messages }
    switch error.httpCode {
    case 401: return [PayinError(nil, text("synqt_error_session_expired"))]
    case 403: return [PayinError(nil, text("synqt_error_not_allowed"))]
    default: return [PayinError(nil, text("synqt_error_http", error.httpCode))]
    }
}

/// Time from `now` to `iso` as "01:59:17", or "" once it has passed. Nil if `iso` is unreadable.
func timeLeft(_ iso: String, _ now: Date) -> String? {
    // SYNQT sends nanoseconds, which ISO8601DateFormatter cannot read; the countdown only needs whole seconds.
    let whole = iso.replacingOccurrences(of: #"\.\d+"#, with: "", options: .regularExpression)
    guard let at = ISO8601DateFormatter().date(from: whole) else { return nil }
    let secs = Int(at.timeIntervalSince(now))
    return secs <= 0 ? "" : String(format: "%02d:%02d:%02d", secs / 3600, secs % 3600 / 60, secs % 60)
}

/// An app's own URL scheme, tried when it does not take SYNQT's https link as a universal link.
let appSchemes = ["SNAPSCAN_QR": "snapscan"]

/// `link`, then the same link on `scheme` if it is an https link.
func appLinks(_ link: String, _ scheme: String?) -> [String] {
    guard let scheme, link.hasPrefix("https://") else { return [link] }
    return [link, scheme + link.dropFirst("https".count)]
}
