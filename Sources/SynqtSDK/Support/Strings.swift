import Foundation

#if SWIFT_PACKAGE
let synqtBundle = Bundle.module
#else
private final class BundleToken {}
/// Built without SwiftPM (CocoaPods or a framework target): the resources sit beside the SDK's own code.
let synqtBundle = Bundle(for: BundleToken.self)
#endif

/// Payer-facing text in the phone's language: the sheet's own wording from Synqt.strings, or the field
/// labels, hints and method names from SynqtForm.strings. Add-ons
/// use it for the sheet's shared wording, such as "Required".
@_spi(SynqtAddon)
public func text(_ key: String, _ args: CVarArg...) -> String {
    let missing = "\u{1}"
    var localized = synqtBundle.localizedString(forKey: key, value: missing, table: "Synqt")
    if localized == missing { localized = synqtBundle.localizedString(forKey: key, value: key, table: "SynqtForm") }
    return args.isEmpty ? localized : String(format: localized, locale: Locale.current, arguments: args)
}
