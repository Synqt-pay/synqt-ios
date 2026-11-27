import SwiftUI

/// The value, unless it is blank or the "-" SYNQT sends for a detail it does not have.
private func shown(_ value: String?) -> String? { value.flatMap { $0.isBlank || $0 == "-" ? nil : $0 } }

/// Synqt-branded payment sheet: wordmark header, order summary, one payer-facing input per field under section
/// headings, and a Pay button pinned to the bottom.
struct PaymentSheetView: View {
    @ObservedObject var model: PaymentSheetModel
    @Environment(\.colorScheme) private var scheme
    private var colors: SynqtColors { .for(scheme) }

    var body: some View {
        VStack(spacing: 0) {
            // The header and Pay bar stay on screen, so they grow less with the text size than the form between them.
            header.measured().dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            Divider().overlay(colors.border)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if let next = model.next { NextStepView(model: model, next: next) } else { formContent }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .measured()
                }
                .onChange(of: model.focusRequest?.count) { _ in
                    guard let target = model.focusRequest?.path else { return }
                    withAnimation { proxy.scrollTo(target, anchor: .top) }
                }
                .onChange(of: model.next) { _ in proxy.scrollTo("top", anchor: .top) }
            }
            // Just above the bar, however tall the bar has grown with its buttons and the text size.
            .overlay(alignment: .bottom) {
                if let toast = model.toast {
                    Text(toast).font(.synqt(16)).foregroundColor(colors.surface).padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Capsule().fill(colors.text)).padding(.bottom, 16)
                }
            }
            Divider().overlay(colors.border)
            bottomBar.measured().dynamicTypeSize(...DynamicTypeSize.accessibility1)
        }
        .onPreferenceChange(MeasuredHeight.self) { model.fitHeight($0 + 2) } // plus the two dividers
        .accessibilityHidden(model.processing) // VoiceOver can't wander into the covered form
        .background(colors.surface.ignoresSafeArea())
        .overlay(processingView.opacity(model.processing ? 1 : 0))
        .tint(colors.action)
    }

    private var header: some View {
        HStack {
            SynqtLogo(ink: colors.logoInk)
            Spacer()
            Button(action: model.close) {
                IconView(icon: .close, color: colors.text).frame(minWidth: 44, minHeight: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(text("synqt_sheet_close"))
        }
        .padding(.leading, 16)
        .padding(.trailing, 6)
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var formContent: some View {
        SummaryCard(summary: model.summary, showSecure: true).id("top")
        if !model.allFilledIn {
            Text(text("synqt_sheet_your_details")).font(.synqt(20, .semibold)).foregroundColor(colors.text).padding(.top, 24)
                .padding(.bottom, model.intro == nil ? 16 : 8)
                .accessibilityAddTraits(.isHeader)
            if let intro = model.intro { Text(intro).font(.synqt(16)).foregroundColor(colors.textMuted).padding(.bottom, 16) }
        }
        ForEach(rows.indices, id: \.self) { index in
            switch rows[index] {
            case .heading(let section):
                if model.inputs.contains(where: { $0.section == section && model.visible($0.path) }) {
                    Text(text(section)).font(.synqt(17, .semibold)).foregroundColor(colors.text).padding(.top, 8).padding(.bottom, 16)
                        .accessibilityAddTraits(.isHeader)
                }
            case .question(let questionIndex):
                if model.questionVisible(questionIndex) { question(questionIndex) }
            case .field(let formField):
                if model.visible(formField.path) { field(formField) }
            }
        }
        if let section = model.addon?.section { section.view.id(PaymentSheetModel.addonID) }
        if let banner = model.banner { SynqtErrorBanner(banner).padding(.bottom, 16).id("banner") }
    }

    private enum Row { case heading(String), question(Int), field(FormField) }

    /// The form in order: a question's tiles and all its fields go where the first of those fields would have been, and
    /// a section heading goes before the first field of each section.
    private var rows: [Row] {
        var rows = [Row]()
        var section: String?
        for input in model.inputs {
            if let questionIndex = model.form.oneOfs.firstIndex(where: { $0.choices.contains { $0.paths.contains(input.path) } }) {
                let paths = model.form.oneOfs[questionIndex].choices.flatMap(\.paths)
                if input.path == paths.first(where: { path in model.inputs.contains { $0.path == path } }) { rows.append(.question(questionIndex)) }
                continue
            }
            if let inputSection = input.section, inputSection != section { rows.append(.heading(inputSection)) }
            section = input.section
            rows.append(.field(input))
        }
        return rows
    }

    private func question(_ questionIndex: Int) -> some View {
        let oneOf = model.form.oneOfs[questionIndex]
        let paths = oneOf.choices.flatMap(\.paths)
        return VStack(alignment: .leading, spacing: 0) {
            Text(text(oneOf.question)).font(.synqt(17, .semibold)).foregroundColor(colors.text).padding(.top, 8).padding(.bottom, 16)
                .accessibilityAddTraits(.isHeader)
            ChoiceTiles(labels: oneOf.choices.map { text($0.label) }, selected: oneOf.choices.firstIndex(of: model.chosen[questionIndex]) ?? 0) {
                model.choose(questionIndex, oneOf.choices[$0])
            }
            .padding(.bottom, 16)
            ForEach(model.inputs.filter { paths.contains($0.path) && model.visible($0.path) }, id: \.path) { field($0) }
        }
    }

    @ViewBuilder
    private func field(_ field: FormField) -> some View {
        if model.banksMissing(field) {
            banksFailed(field).id(field.path)
        } else if let options = model.options(field) {
            SynqtDropdown(text(field.label), selection: model.binding(field), options: options, helper: model.hint(field), error: model.marks[field.path])
                .id(field.path)
        } else {
            let keyboard: SynqtKeyboard = field.kind == .email ? .email : field.kind == .phone ? .phone : field.kind == .number ? .number
                : field.path.hasSuffix("Name") ? .name : .text
            SynqtTextField(text(field.label), text: model.binding(field), helper: model.hint(field),
                           placeholder: field.placeholder.map { text($0) } ?? "", error: model.marks[field.path], keyboard: keyboard)
                .focus(request: model.focusRequest?.path == field.path ? model.focusRequest!.count : 0) { model.focus(field.path, $0) }
                .autoFill(field.path)
                .id(field.path)
        }
    }

    /// In place of a bank or provider field whose list didn't load: the label, why, and Try again.
    private func banksFailed(_ field: FormField) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text(field.label)).font(.synqt(16, .medium)).foregroundColor(colors.text)
            SynqtErrorBanner(text("synqt_sheet_banks_failed"))
            Button(action: model.retryBanks) {
                ZStack {
                    Text(text("synqt_sheet_try_again")).opacity(model.loadingBanks ? 0 : 1)
                    if model.loadingBanks { ProgressView() }
                }
            }
            .buttonStyle(SynqtButtonStyle(.outline))
            .disabled(model.loadingBanks)
            .accessibilityLabel(text("synqt_sheet_try_again"))
        }
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var bottomBar: some View {
        VStack(spacing: 8) {
            if let next = model.next {
                if next.appLink != nil {
                    Button(text("synqt_next_open_app", model.methodName), action: model.openApp).buttonStyle(SynqtButtonStyle(.primary))
                }
                Button(text("synqt_next_done"), action: model.close).buttonStyle(SynqtButtonStyle(next.appLink != nil ? .outline : .primary))
            } else {
                Button(text("synqt_sheet_pay", model.summary.amount), action: model.pay).buttonStyle(SynqtButtonStyle(.primary)).monospacedDigit()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private var processingView: some View {
        VStack(spacing: 0) {
            OrbitLoader().frame(width: 72, height: 72)
            Text(text("synqt_sheet_processing")).font(.synqt(20, .semibold)).foregroundColor(colors.text).padding(.top, 24).padding(.bottom, 8)
            Text(text("synqt_sheet_processing_detail")).font(.synqt(16)).foregroundColor(colors.textMuted)
        }
        .multilineTextAlignment(.center)
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colors.surface.ignoresSafeArea())
        .accessibilityElement(children: .combine)
        .allowsHitTesting(model.processing) // keeps taps off the form underneath
    }
}

#if os(iOS)
/// What iOS may offer from the payer's contact card for a field; email and phone get theirs from `SynqtKeyboard`.
private let autoFillTypes: [String: UITextContentType] = [
    "customerName.titleBefore": .namePrefix, "customerName.firstName": .givenName, "customerName.middleName": .middleName,
    "customerName.lastName": .familyName, "customerName.titleAfter": .nameSuffix, "account.accountName": .name,
    "paymentLocation.postalCode": .postalCode, "paymentLocation.city": .addressCity,
]
#endif

private extension View {
    @ViewBuilder
    func autoFill(_ path: String) -> some View {
        #if os(iOS)
        if let type = autoFillTypes[path] { textContentType(type) } else { self }
        #else
        self
        #endif
    }
}

/// Sum of the heights of the views marked `measured()`: the header, the whole form and the Pay bar.
private struct MeasuredHeight: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value += nextValue() }
}

private extension View {
    func measured() -> some View {
        background(GeometryReader { Color.clear.preference(key: MeasuredHeight.self, value: $0.size.height) })
    }
}

/// One of several answers, as tiles: the chosen tile on action-tint with its border and radio dot in the action colour.
/// VoiceOver reads each as a button, "selected" on the chosen one.
private struct ChoiceTiles: View {
    @Environment(\.colorScheme) private var scheme
    let labels: [String]
    let selected: Int
    let onSelect: (Int) -> Void

    var body: some View {
        let colors = SynqtColors.for(scheme)
        VStack(spacing: 8) {
            ForEach(labels.indices, id: \.self) { index in
                let on = index == selected
                Button { onSelect(index) } label: {
                    HStack(spacing: 12) {
                        Circle().strokeBorder(on ? colors.action : colors.textMuted, lineWidth: 2).frame(width: 20, height: 20)
                            .overlay(Circle().fill(on ? colors.action : .clear).padding(5))
                        Text(labels[index]).font(.synqt(16, .medium)).foregroundColor(colors.text)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 16)
                    .frame(minHeight: 56)
                    .background(RoundedRectangle(cornerRadius: 12).fill(on ? colors.actionTint : colors.surface))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(on ? colors.action : colors.borderControl, lineWidth: on ? 2 : 1))
                    .contentShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(on ? .isSelected : [])
            }
        }
    }
}

/// The checkout's order summary: amount due in large type, then who, how and which order.
private struct SummaryCard: View {
    @Environment(\.colorScheme) private var scheme
    let summary: PaymentSummary
    var showReference = true
    /// The form's summary ends with "Secure checkout", which scrolls with it rather than taking room from the Pay bar.
    var showSecure = false

    var body: some View {
        let colors = SynqtColors.for(scheme)
        VStack(alignment: .leading, spacing: 0) {
            // Eyebrow, not brand magenta: magenta on the light panel is 2.89:1.
            Eyebrow(text("synqt_sheet_amount_due"))
            Text(summary.amount).font(.synqt(28, .semibold)).monospacedDigit().foregroundColor(colors.text).padding(.top, 4).padding(.bottom, 16)
            Divider().overlay(colors.border)
            if let merchant = summary.merchant { DetailRow(label: text("synqt_sheet_paying"), value: merchant) }
            DetailRow(label: text("synqt_sheet_payment_method"), value: summary.method)
            if showReference { DetailRow(label: text("synqt_sheet_reference"), value: summary.reference) }
            if showSecure {
                HStack(spacing: 8) {
                    IconView(icon: .lock, size: 16, color: colors.textMuted)
                    Text(text("synqt_sheet_secure_checkout")).font(.synqt(13)).foregroundColor(colors.textMuted).multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(colors.surfacePanel))
    }
}

private struct Eyebrow: View {
    @Environment(\.colorScheme) private var scheme
    let value: String

    init(_ value: String) { self.value = value }

    var body: some View {
        Text(value.uppercased()).font(.synqt(13, .medium)).kerning(1).foregroundColor(SynqtColors.for(scheme).eyebrow)
    }
}

/// A label and value; with `copy`, a button that copies that text. In a card with copy buttons every row keeps the
/// button's column, so values line up.
private struct DetailRow: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dynamicTypeSize) private var typeSize
    let label: String
    let value: String
    var copy: String?
    var copyColumn = false
    var onCopy: (String, String) -> Void = { _, _ in }

    var body: some View {
        let colors = SynqtColors.for(scheme)
        let labelText = Text(label).font(.synqt(16)).foregroundColor(colors.textMuted)
        let valueText = Text(value).font(.synqt(16, .medium)).monospacedDigit().foregroundColor(colors.text) // tabular, so amounts and numbers line up
        HStack(spacing: 0) {
            Group {
                // Side by side, accessibility text sizes break words mid-word, so label and value stack instead.
                if typeSize.isAccessibilitySize {
                    VStack(alignment: .leading, spacing: 4) { labelText; valueText }
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    labelText.padding(.trailing, 16)
                    Spacer(minLength: 0)
                    valueText.multilineTextAlignment(.trailing)
                }
            }
            .accessibilityElement(children: .combine) // the copy button stays its own element
            if copyColumn {
                let icon = IconView(icon: .copy, size: 20, color: colors.textMuted).frame(minWidth: 44, minHeight: 44)
                if let copy {
                    Button { onCopy(label, copy) } label: { icon }
                        .buttonStyle(.plain)
                        .accessibilityLabel(text("synqt_next_copy", label))
                } else {
                    icon.hidden() // keeps the copy column, so values line up
                }
            }
        }
        .padding(.top, 8)
    }
}

/// What the payer does after SYNQT accepted the payment, for methods finished in another app or by bank transfer.
private struct NextStepView: View {
    @ObservedObject var model: PaymentSheetModel
    let next: NextStep
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let colors = SynqtColors.for(scheme)
        let transfer = next.payInto
        let amount = next.amountToPay?.description ?? model.summary.amount
        let name = model.methodName
        let how = transfer != nil ? text("synqt_next_transfer")
            : next.appLink != nil && next.qrCodeImageURL != nil ? text("synqt_next_open_or_scan", name)
            : next.appLink != nil ? text("synqt_next_open", name) : text("synqt_next_scan", name)
        // A transfer reference that contains the order ID would read as a second, near-identical "Reference", so the order ID goes.
        let orderIdInReference = transfer != nil && next.reference?.contains(model.summary.reference) == true
        var summary = model.summary
        summary.amount = amount
        let reference = transfer != nil ? next.reference : nil

        return VStack(alignment: .leading, spacing: 0) {
            SummaryCard(summary: summary, showReference: !orderIdInReference).id("top")
            // The countdown (with a transfer's reference) sits in one card above the instructions, the same for every method.
            if reference != nil || next.expiresAt != nil {
                ReferenceCard(reference: reference, expiresAt: next.expiresAt) { model.copyValue(text("synqt_sheet_reference"), $0) }
                    .padding(.top, 24).padding(.bottom, 8)
            }
            Text(transfer != nil ? text("synqt_next_transfer_title") : text("synqt_next_title", name))
                .font(.synqt(20, .semibold)).foregroundColor(colors.text).padding(.top, 24).padding(.bottom, 8).accessibilityAddTraits(.isHeader)
            Text(how).font(.synqt(16)).foregroundColor(colors.textMuted).padding(.bottom, 8)
            if let exact = next.amountToPay {
                Text(text("synqt_next_pay_exactly", exact.description)).font(.synqt(16, .medium)).monospacedDigit().foregroundColor(colors.text).padding(.bottom, 8)
            }
            if let account = transfer {
                // A banking app wants the number alone, not "R100.00".
                let copyAmount = next.amountToPay.map { ($0.amount as NSDecimalNumber).stringValue } ?? amount.filter { $0.isNumber || $0 == "." }
                transferCard(account, amount, copyAmount, colors).padding(.vertical, 8)
                notice(colors)
            } else if let ref = next.reference {
                Text(text("synqt_next_reference", ref)).font(.synqt(16, .medium)).foregroundColor(colors.text).padding(.bottom, 8)
            }
            if let qr = next.qrCodeImageURL.flatMap(URL.init(string:)) { qrCode(qr, colors) }
            if let problem = model.appProblem { SynqtErrorBanner(problem).padding(.bottom, 16) }
        }
    }

    /// The bank details an OFFLINE payer types into their own banking app, each with a copy button.
    private func transferCard(_ account: PaymentMethodResponse.Account, _ amount: String, _ copyAmount: String, _ colors: SynqtColors) -> some View {
        // Branch is the primary detail and often repeats the bank code, so the bank code only stands in when there is no branch.
        let branch: (String, String, String?)? = shown(account.bankBranch).map { (text("synqt_next_branch"), $0, $0) }
            ?? shown(account.bankCode).map { (text("synqt_next_bank_code"), $0, $0) }
        let rows: [(String, String, String?)] = [
            shown(account.accountName).map { (text("synqt_next_account_name"), $0, $0) },
            shown(account.accountNumber).map { (text("synqt_next_account_number"), $0, $0) },
            shown(account.bankName).map { (text("synqt_next_bank"), $0, nil) },
            shown(account.accountType).map { (text("synqt_next_account_type"), $0, nil) },
            branch,
            (text("synqt_sheet_amount_due"), amount, copyAmount),
        ].compactMap { $0 }
        return VStack(spacing: 0) {
            ForEach(rows.indices, id: \.self) { index in
                DetailRow(label: rows[index].0, value: rows[index].1, copy: rows[index].2, copyColumn: true, onCopy: model.copyValue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(RoundedRectangle(cornerRadius: 12).fill(colors.surfacePanel))
    }

    /// What the payer must know before transferring.
    private func notice(_ colors: SynqtColors) -> some View {
        let items = ["synqt_next_notice_exact", "synqt_next_notice_once", "synqt_next_notice_fees", "synqt_next_notice_own_account"]
        return VStack(alignment: .leading, spacing: 8) {
            Text(text("synqt_next_notice_title")).font(.synqt(16, .medium)).foregroundColor(colors.text).accessibilityAddTraits(.isHeader)
            ForEach(items.indices, id: \.self) { index in
                Text(text("synqt_next_notice_item", index + 1, text(items[index]))).font(.synqt(16)).foregroundColor(colors.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    /// SYNQT's QR image, on white in both themes because scanners need a light ground.
    private func qrCode(_ url: URL, _ colors: SynqtColors) -> some View {
        AsyncImage(url: url) { phase in
            VStack(spacing: 8) {
                switch phase {
                case .success(let image):
                    image.resizable().interpolation(.none).scaledToFit().padding(12).frame(width: 240, height: 240)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(colors.border))
                        .accessibilityLabel(text("synqt_next_qr_description", model.methodName))
                    Text(text("synqt_next_qr_caption", model.methodName)).font(.synqt(13)).foregroundColor(colors.textMuted)
                case .failure:
                    Text(text("synqt_next_qr_failed")).font(.synqt(13)).foregroundColor(colors.textMuted)
                default:
                    RoundedRectangle(cornerRadius: 12).fill(Color.white).frame(width: 240, height: 240)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(colors.border))
                    Text(text("synqt_next_qr_loading")).font(.synqt(13)).foregroundColor(colors.textMuted)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

/// The countdown card at the top of every next step; for OFFLINE it leads with the reference the payer must quote, as
/// a missing one fails the payment.
private struct ReferenceCard: View {
    @Environment(\.colorScheme) private var scheme
    let reference: String?
    let expiresAt: String?
    let onCopy: (String) -> Void

    var body: some View {
        let colors = SynqtColors.for(scheme)
        VStack(alignment: .trailing, spacing: 0) {
            if let reference {
                Eyebrow(text("synqt_next_reference_title"))
                HStack(spacing: 0) {
                    Text(reference).font(.synqt(24, .semibold)).foregroundColor(colors.text).textSelection(.enabled).multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Button { onCopy(reference) } label: { IconView(icon: .copy, size: 20, color: colors.textMuted).frame(minWidth: 44, minHeight: 44) }
                        .buttonStyle(.plain)
                        .accessibilityLabel(text("synqt_next_copy", text("synqt_sheet_reference")))
                        .padding(.trailing, -12) // the icon itself ends on the card's edge, like the time below
                }
                Text(text("synqt_next_reference_needed")).font(.synqt(14)).foregroundColor(colors.textMuted).multilineTextAlignment(.trailing)
            }
            if let expiresAt {
                if reference != nil { Divider().overlay(colors.border).padding(.top, 16).padding(.bottom, 8) }
                Countdown(expiresAt: expiresAt)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(RoundedRectangle(cornerRadius: 12).fill(colors.surface))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(colors.border))
    }
}

/// "Time left to pay" over a large "01:59:17", ticking every second until `expiresAt`, then a line saying time ran out.
private struct Countdown: View {
    @Environment(\.colorScheme) private var scheme
    let expiresAt: String

    var body: some View {
        let colors = SynqtColors.for(scheme)
        TimelineView(.periodic(from: .now, by: 1)) { context in
            if let left = timeLeft(expiresAt, context.date) {
                if left.isEmpty {
                    Text(text("synqt_next_expired")).font(.synqt(16)).foregroundColor(colors.danger).multilineTextAlignment(.trailing)
                } else {
                    VStack(alignment: .trailing, spacing: 0) {
                        Eyebrow(text("synqt_next_time_left"))
                        HStack(spacing: 8) {
                            IconView(icon: .timer, size: 28, color: colors.text)
                            Text(left).font(.synqt(28, .semibold)).monospacedDigit().foregroundColor(colors.text)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(text("synqt_next_time_left") + " " + left)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
