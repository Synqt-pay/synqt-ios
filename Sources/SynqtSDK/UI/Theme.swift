import CoreText
import SwiftUI

extension Color {
    init(rgb: UInt32, alpha: UInt32 = 0xFF) {
        self.init(.sRGB, red: Double(rgb >> 16 & 0xFF) / 255, green: Double(rgb >> 8 & 0xFF) / 255,
                  blue: Double(rgb & 0xFF) / 255, opacity: Double(alpha) / 255)
    }
}

public enum SynqtWeight: Sendable { case regular, medium, semibold }

public extension Font {
    /// Instrument Sans at `size` points on the mobile type scale, growing with the payer's Dynamic Type setting. Falls back to
    /// the system font if Instrument Sans cannot be loaded.
    static func synqt(_ size: CGFloat, _ weight: SynqtWeight = .regular) -> Font {
        _ = fontsRegistered
        let name: String
        switch weight {
        case .regular: name = "InstrumentSans-Regular"
        case .medium: name = "InstrumentSans-Medium"
        case .semibold: name = "InstrumentSans-SemiBold"
        }
        let style: Font.TextStyle = size <= 13 ? .footnote : size <= 16 ? .body : size <= 17 ? .headline : size <= 20 ? .title3 : .title
        return .custom(name, size: size, relativeTo: style)
    }
}

/// Registers the SDK's Instrument Sans files for this process, once, so apps need no Info.plist entry.
private let fontsRegistered: Void = {
    for url in synqtBundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? [] {
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}()
