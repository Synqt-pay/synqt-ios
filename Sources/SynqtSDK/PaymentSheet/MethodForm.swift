import Foundation

/// How the payment sheet asks for a field. `operator` lists the banks or providers availablePaymentOptions returns for
/// the method; `provider` lists the external providers of those banks.
enum FieldKind { case text, email, phone, number, choice, `operator`, provider }

/// Every provider of `operators`, once each, whichever bank the payer picks.
func providers(_ operators: [PaymentOperatorIncoming]) -> [ExternalProvider] {
    var seen = Set<String>()
    return operators.flatMap { $0.externalProviders?.providers ?? [] }.filter { $0.code.map { seen.insert($0).inserted } ?? false }
}

/// One payer-facing input for a text field of a payment method, keyed by its JSON path (e.g. `customerName.lastName`).
/// Text is held as string keys (Resources/en.lproj/SynqtForm.strings) so it can be translated.
struct FormField: Sendable {
    let path: String
    let label: String
    let kind: FieldKind
    let required: Bool
    let hint: String?
    /// Shown inside the empty field instead of `hint` under it: an example of what to type.
    let placeholder: String?
    /// Heading of the group this field sits in, such as "Bank account".
    let section: String?
    let minLength: Int?
    let maxLength: Int?
    /// From the spec; matched anywhere in the value, as JSON Schema does.
    let pattern: String?
    let invalid: String?
    /// `choice` values sent to SYNQT, with the label shown for each.
    let options: [(value: String, label: String)]

    init(_ path: String, _ label: String, _ kind: FieldKind, required: Bool, hint: String? = nil, placeholder: String? = nil, section: String? = nil,
         minLength: Int? = nil, maxLength: Int? = nil, pattern: String? = nil, invalid: String? = nil,
         options: [(value: String, label: String)] = []) {
        self.path = path
        self.label = label
        self.kind = kind
        self.required = required
        self.hint = hint
        self.placeholder = placeholder
        self.section = section
        self.minLength = minLength
        self.maxLength = maxLength
        self.pattern = pattern
        self.invalid = invalid
        self.options = options
    }
}

/// One answer to a `OneOf` question. Once it is chosen its `required` paths must be filled in (none, for an optional
/// question); the rest are optional.
struct Choice: Equatable, Sendable {
    let label: String
    let paths: [String]
    let required: [String]

    init(_ label: String, _ paths: [String], required: [String]? = nil) {
        self.label = label
        self.paths = paths
        self.required = required ?? Array(paths.prefix(1))
    }
}

/// The payer gives one of several details. The first choice is the default; the other choices' fields are hidden and not sent.
struct OneOf: Sendable {
    let question: String
    let choices: [Choice]

    init(_ question: String, _ choices: [Choice]) {
        self.question = question
        self.choices = choices
    }
}

/// A direct API method's inputs and how they become the typed `PaymentMethodPayin`. Instances live in MethodFormData.swift.
struct MethodForm: Sendable {
    let code: String
    let name: String
    let fields: [FormField]
    let oneOfs: [OneOf]
    let build: @Sendable (FormValues) throws -> PaymentMethodPayin

    init(_ code: String, _ name: String, _ fields: [FormField], oneOfs: [OneOf] = [], build: @escaping @Sendable (FormValues) throws -> PaymentMethodPayin) {
        self.code = code
        self.name = name
        self.fields = fields
        self.oneOfs = oneOfs
        self.build = build
    }

    /// The first choice of each question, which the sheet starts with.
    var defaultChoices: [Choice] { oneOfs.map { $0.choices[0] } }

    /// Whether the field at `path` is shown, checked and sent while `chosen` (one per question, in order) is picked. A
    /// question with nothing chosen, as when `chosen` is empty, shows all its fields.
    func shows(_ path: String, _ chosen: [Choice]) -> Bool {
        zip(oneOfs, chosen).allSatisfy { question, choice in
            choice.paths.contains(path) || !question.choices.contains { $0.paths.contains(path) }
        }
    }

    /// Payer-facing problems with `values`, by field path, found before anything is sent.
    func problems(_ values: [String: String], _ chosen: [Choice]? = nil) -> [PayinError] {
        let chosen = chosen ?? defaultChoices
        return fields.filter { shows($0.path, chosen) }.compactMap { field in
            problem(field, values, mustFill: chosen.contains { $0.required.contains(field.path) })
        }
    }

    /// Fields the sheet can leave out of view: those the app prefilled whose value is still in place and passes its
    /// checks. Once the first and last name are filled in, the name's optional extras (title, middle name, suffix) are
    /// left out too, so the whole name section goes. `values` are the form's current values, as read from the sheet.
    func filledIn(_ values: [String: String], _ prefill: [String: String], _ chosen: [Choice]) -> [String] {
        let filled = fields.filter { field in
            let value = values[field.path] ?? ""
            return !value.isBlank && value == prefill[field.path] && problem(field, values, mustFill: chosen.contains { $0.required.contains(field.path) }) == nil
        }.map(\.path)
        let named = ["customerName.firstName", "customerName.lastName"].allSatisfy(filled.contains)
        let extras = !named ? [] : fields.filter { field in
            field.path.hasPrefix("customerName.") && !filled.contains(field.path) && !field.required && (values[field.path] ?? "").isBlank
        }.map(\.path)
        return filled + extras
    }

    /// True when the payer has nothing left to give: the method has mandatory fields, every one shown for `chosen` is in
    /// `filledIn`, and nothing fails its checks. Methods with only optional fields keep their form for the payer.
    func readyToPay(_ values: [String: String], _ filledIn: [String], _ chosen: [Choice]) -> Bool {
        let mandatory = fields.filter { field in shows(field.path, chosen) && (field.required || chosen.contains { $0.required.contains(field.path) }) }
        return !mandatory.isEmpty && mandatory.allSatisfy { filledIn.contains($0.path) } && problems(values, chosen).isEmpty
    }
}

/// The problem with one field, if any. `mustFill` is for the required fields of the chosen `Choice`, which the spec
/// itself marks optional.
func problem(_ field: FormField, _ values: [String: String], mustFill: Bool = false) -> PayinError? {
    let value = (values[field.path] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    let malformed = !value.isEmpty && (
        field.minLength.map { value.count < $0 } == true ||
            field.maxLength.map { value.count > $0 } == true ||
            field.pattern.map { value.range(of: $0, options: .regularExpression) == nil } == true ||
            field.kind == .email && value.range(of: #"^[^@\s]+@[^@\s]+\.[^@\s]+$"#, options: .regularExpression) == nil
    )
    if value.isEmpty && (mustFill || field.required) { return PayinError(field.path, text("synqt_sheet_required")) }
    if malformed { return PayinError(field.path, text(field.invalid ?? "synqt_sheet_check_field")) }
    return nil
}

/// A problem to show the payer: the field it is about (a JSON path, or SYNQT's attrCode), if any, and what to say.
struct PayinError: Equatable {
    let attr: String?
    let text: String

    init(_ attr: String?, _ text: String) {
        self.attr = attr
        self.text = text
    }
}

/// Form input by JSON path. Blank means not set, so optional fields are left out of the request.
struct FormValues {
    let values: [String: String]

    func str(_ path: String) -> String? {
        let value = values[path]?.trimmingCharacters(in: .whitespacesAndNewlines)
        return value?.isEmpty == false ? value : nil
    }

    /// A required value; throws `SynqtArgumentError` with `path`, so the sheet knows which input to mark.
    func req(_ path: String) throws -> String {
        guard let value = str(path) else { throw SynqtArgumentError("\(path) is required", path: path) }
        return value
    }

    /// Builds an optional nested object only when at least one of its fields is filled in.
    func group<T>(_ prefix: String, _ build: () throws -> T) rethrows -> T? {
        values.contains { $0.key.hasPrefix(prefix + ".") && !$0.value.isBlank } ? try build() : nil
    }
}

extension String {
    var isBlank: Bool { trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}

/// The payer-facing name of `code`, or nil if the sheet does not support it.
func methodName(_ code: String?) -> String? {
    methodForms.first { $0.code == code }.map { text($0.name) } ?? Addons.shared.all.first { $0.code == code }?.name
}
