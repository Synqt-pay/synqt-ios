import SwiftUI

// Synqt-styled views: the building blocks of the SDK's payment sheet, for apps that want their own screens to match.
// Mobile type scale in Instrument Sans, spacing in 4, 8, 16 and 24pt, 12pt cards and inputs, 48pt pill buttons, a visible focus
// ring, light and dark. Colours follow the screen's colour scheme (see SynqtColors).

/// A panel with a title in the mobile subtitle style (20pt Regular).
public struct SynqtCard<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    let title: String
    let content: Content

    public init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        let colors = SynqtColors.for(scheme)
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.synqt(20)).foregroundColor(colors.text)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(colors.surface))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(colors.border))
    }
}

/// The keyboard and text handling for a `SynqtTextField`.
public enum SynqtKeyboard: Sendable { case text, name, email, phone, number }

/// Label above, input, helper below. A non-nil `error` replaces the helper and turns the edge red. `placeholder` shows
/// in the empty input instead.
public struct SynqtTextField: View {
    @Environment(\.colorScheme) private var scheme
    @FocusState private var focused: Bool
    /// What the field shows. TextField keeps showing a keystroke its binding refused (a digit past the limit), so the
    /// refused text is put back from `text` here.
    @State private var draft: String
    let label: String
    @Binding var text: String
    let helper: String
    let placeholder: String
    let error: String?
    let keyboard: SynqtKeyboard
    var focusRequest = 0
    var onFocusChange: (Bool) -> Void = { _ in }
    var configure: ((TextField<Text>) -> AnyView)?

    public init(_ label: String, text: Binding<String>, helper: String = "", placeholder: String = "", error: String? = nil, keyboard: SynqtKeyboard = .text) {
        self.label = label
        _text = text
        _draft = State(initialValue: text.wrappedValue)
        self.helper = helper
        self.placeholder = placeholder
        self.error = error
        self.keyboard = keyboard
    }

    /// For the sheet and add-ons: focuses the field whenever `request` changes, and reports focus moving in or out.
    @_spi(SynqtAddon)
    public func focus(request: Int, onChange: @escaping (Bool) -> Void) -> SynqtTextField {
        var copy = self
        copy.focusRequest = request
        copy.onFocusChange = onChange
        return copy
    }

    /// For add-ons: sets up the input itself (keyboard, AutoFill and the like) in place of `keyboard`.
    @_spi(SynqtAddon)
    public func input<V: View>(_ configure: @escaping (TextField<Text>) -> V) -> SynqtTextField {
        var copy = self
        copy.configure = { AnyView(configure($0)) }
        return copy
    }

    @ViewBuilder
    private func input(_ field: TextField<Text>) -> some View {
        if let configure { configure(field) } else { field.keyboard(keyboard) }
    }

    public var body: some View {
        let colors = SynqtColors.for(scheme)
        VStack(alignment: .leading, spacing: 0) {
            Text(label).font(.synqt(16, .medium)).foregroundColor(colors.text).padding(.bottom, 8)
            input(TextField("", text: $draft, prompt: Text(placeholder).foregroundColor(colors.textMuted)))
                .font(.synqt(16))
                .foregroundColor(colors.text)
                .focused($focused)
                .padding(.horizontal, 16)
                .frame(minHeight: 52)
                .background(RoundedRectangle(cornerRadius: 12).fill(colors.surface))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(focused ? colors.focusRing : error != nil ? colors.danger : colors.borderControl, lineWidth: focused ? 2 : 1))
                .accessibilityLabel(label)
                .accessibilityHint(error ?? (helper.isEmpty ? placeholder : helper))
            helperText(error ?? helper, error != nil, colors)
        }
        .padding(.bottom, 16)
        .onChange(of: draft) { typed in
            text = typed
            if text != typed { draft = text }
        }
        .onChange(of: text) { if $0 != draft { draft = $0 } }
        .onChange(of: focused, perform: onFocusChange)
        .onChange(of: focusRequest) { if $0 > 0 { focused = true } }
    }
}

/// Labelled dropdown in the input's style. `options` pairs the value to keep with the text to show; `error` works as
/// on `SynqtTextField`.
public struct SynqtDropdown: View {
    @Environment(\.colorScheme) private var scheme
    let label: String
    @Binding var selection: String
    let options: [(value: String, label: String)]
    let helper: String
    let error: String?

    public init(_ label: String, selection: Binding<String>, options: [(value: String, label: String)], helper: String = "", error: String? = nil) {
        self.label = label
        _selection = selection
        self.options = options
        self.helper = helper
        self.error = error
    }

    public var body: some View {
        let colors = SynqtColors.for(scheme)
        let shown = options.first { $0.value == selection }?.label ?? options.first?.label ?? ""
        VStack(alignment: .leading, spacing: 0) {
            Text(label).font(.synqt(16, .medium)).foregroundColor(colors.text).padding(.bottom, 8)
            Menu {
                ForEach(options.indices, id: \.self) { index in
                    Button(options[index].label) { selection = options[index].value }
                }
            } label: {
                HStack {
                    Text(shown).font(.synqt(16)).foregroundColor(colors.text).multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    IconView(icon: .chevronDown, color: colors.text)
                }
                .padding(.horizontal, 16)
                .frame(minHeight: 52)
                .background(RoundedRectangle(cornerRadius: 12).fill(colors.surface))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(error != nil ? colors.danger : colors.borderControl))
            }
            .accessibilityLabel(label)
            .accessibilityValue(shown)
            .accessibilityHint(error ?? helper)
            helperText(error ?? helper, error != nil, colors)
        }
        .padding(.bottom, 16)
    }
}

/// PRIMARY is the action colour (one per screen), ACCENT is brand magenta for dark sections, OUTLINE is secondary.
public struct SynqtButtonStyle: ButtonStyle {
    public enum Kind: Sendable { case primary, accent, outline }

    @Environment(\.colorScheme) private var scheme
    let kind: Kind

    public init(_ kind: Kind) { self.kind = kind }

    public func makeBody(configuration: Configuration) -> some View {
        let colors = SynqtColors.for(scheme)
        let (fill, label): (Color, Color)
        switch kind {
        case .primary: (fill, label) = (colors.action, colors.onAction)
        // White on brand magenta is 3.29:1, so the label is Off-Blue Black (5.14:1).
        case .accent: (fill, label) = (SynqtColors.magenta, colors.onAccent)
        case .outline: (fill, label) = (colors.surface, colors.text)
        }
        return configuration.label
            .font(.synqt(16, .medium))
            .foregroundColor(label)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Capsule().fill(fill))
            .overlay(Capsule().strokeBorder(kind == .outline ? colors.borderControl : .clear))
            .overlay(Capsule().fill(configuration.isPressed ? colors.pressedOverlay : .clear))
            .contentShape(Capsule())
    }
}

/// Error banner: the words lead, with a warning icon, so colour is never the only cue.
public struct SynqtErrorBanner: View {
    @Environment(\.colorScheme) private var scheme
    let message: String

    public init(_ message: String) { self.message = message }

    public var body: some View {
        let colors = SynqtColors.for(scheme)
        HStack(alignment: .top, spacing: 8) {
            IconView(icon: .warning, color: colors.danger)
            Text(message).font(.synqt(16)).foregroundColor(colors.danger).frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 12).fill(colors.dangerTint))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(colors.dangerLine))
        .accessibilityElement(children: .combine)
    }
}

@ViewBuilder
private func helperText(_ value: String, _ isError: Bool, _ colors: SynqtColors) -> some View {
    if !value.isEmpty {
        Text(value).font(.synqt(13)).foregroundColor(isError ? colors.danger : colors.textMuted).padding(.top, 4)
            .accessibilityHidden(true) // read as the field's hint instead
    }
}

private extension View {
    @ViewBuilder
    func keyboard(_ kind: SynqtKeyboard) -> some View {
        #if os(iOS)
        switch kind {
        case .text: self
        case .name: self.textInputAutocapitalization(.words)
        case .email: self.keyboardType(.emailAddress).textInputAutocapitalization(.never).disableAutocorrection(true).textContentType(.emailAddress)
        case .phone: self.keyboardType(.phonePad).disableAutocorrection(true).textContentType(.telephoneNumber)
        case .number: self.keyboardType(.numberPad).disableAutocorrection(true)
        }
        #else
        self
        #endif
    }
}
