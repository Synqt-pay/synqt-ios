import SwiftUI

/**
 Synqt semantic colour tokens from the synqt-brand-design skill (design system artefact, 26 October 2026), the same
 values as the Android SDK's synqt_colors.xml. Pick the set for the screen's colour scheme with `SynqtColors.for(_:)`.
 Generated: don't edit by hand.
 */
public struct SynqtColors: Sendable {
    public let surface: Color
    public let surfacePanel: Color
    public let text: Color
    public let textMuted: Color
    /// Example text in an empty field, lighter than typed text so it can't pass for it: 4.73:1 on the light surface, 4.96:1 on the dark one. Approved by the Innovation Manager, 24 Nov 2026.
    public let placeholder: Color
    public let onAccent: Color
    public let action: Color
    public let onAction: Color
    /// Dark: magenta at 12%.
    public let actionTint: Color
    public let eyebrow: Color
    public let border: Color
    /// slate-muted: a 3:1 field edge in both themes (brand owner, 26 Oct 2026).
    public let borderControl: Color
    public let focusRing: Color
    public let logoInk: Color
    public let pressedOverlay: Color
    /// The icon, border and words of an error. Dark: danger-light (brand owner, 26 Oct 2026): #B4232C is 2.59:1 on the dark surface, this is 9.98:1.
    public let danger: Color
    /// Frames the error banner, with danger_line.
    public let dangerTint: Color
    public let dangerLine: Color

    public static let magenta = Color(rgb: 0xF318FF)
    /// For the Orbit loader only. The brand keeps aqua for dark grounds; its use on light is an open point.
    public static let aqua = Color(rgb: 0x27FFE2)

    public static let light = SynqtColors(
        surface: Color(rgb: 0xFFFFFF),
        surfacePanel: Color(rgb: 0xF0F0F0),
        text: Color(rgb: 0x1A1C29),
        textMuted: Color(rgb: 0x4E5670),
        placeholder: Color(rgb: 0x6B7389),
        onAccent: Color(rgb: 0x1A1C29),
        action: Color(rgb: 0xB505BF),
        onAction: Color(rgb: 0xFFFFFF),
        actionTint: Color(rgb: 0xFEEEFF),
        eyebrow: Color(rgb: 0xB505BF),
        border: Color(rgb: 0xE7EAF2),
        borderControl: Color(rgb: 0x7A8296),
        focusRing: Color(rgb: 0x1A1C29),
        logoInk: Color(rgb: 0x1A1C29),
        pressedOverlay: Color(rgb: 0x1A1C29, alpha: 0x33),
        danger: Color(rgb: 0xB4232C),
        dangerTint: Color(rgb: 0xFCEBEC),
        dangerLine: Color(rgb: 0xF2D1D3))

    public static let dark = SynqtColors(
        surface: Color(rgb: 0x1A1C29),
        surfacePanel: Color(rgb: 0x212536),
        text: Color(rgb: 0xFFFFFF),
        textMuted: Color(rgb: 0xA7AFC5),
        placeholder: Color(rgb: 0x838B9F),
        onAccent: Color(rgb: 0x1A1C29),
        action: Color(rgb: 0xF318FF),
        onAction: Color(rgb: 0x1A1C29),
        actionTint: Color(rgb: 0xF318FF, alpha: 0x1F),
        eyebrow: Color(rgb: 0xF470FF),
        border: Color(rgb: 0x2A2F42),
        borderControl: Color(rgb: 0x7A8296),
        focusRing: Color(rgb: 0x27FFE2),
        logoInk: Color(rgb: 0xFFFFFF),
        pressedOverlay: Color(rgb: 0xFFFFFF, alpha: 0x33),
        danger: Color(rgb: 0xFFB4AE),
        dangerTint: Color(rgb: 0x212536),
        dangerLine: Color(rgb: 0xFFB4AE))

    public static func `for`(_ scheme: ColorScheme) -> SynqtColors { scheme == .dark ? dark : light }
}
