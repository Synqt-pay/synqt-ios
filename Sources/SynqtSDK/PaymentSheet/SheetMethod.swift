import SwiftUI

// For SYNQT's own add-ons, such as the card add-on. Apps never need it, and it may change in any release: it is SPI,
// so only `@_spi(SynqtAddon) import SynqtSDK` sees it.

/**
 A payment method an add-on adds to the payment sheet, registered with `Synqt.addMethod`. The sheet keeps its header,
 summary, Pay button, processing state, general errors and next steps; the add-on draws, checks and builds only its own
 fields, so what the payer types there never reaches the base SDK.
 */
@_spi(SynqtAddon)
public protocol SheetMethod: Sendable {
    /// The `paymentMethodCode`, such as `CARD`.
    var code: String { get }
    /// The payer-facing name, in the phone's language.
    var name: String { get }
    /// True covers the sheet while the app is in the app switcher and while the screen is recorded or mirrored.
    var secure: Bool { get }
    /// The method's fields, for one sheet. `prefill` is the app's, as given to `Payin.presentPaymentSheet`.
    @MainActor func section(payin: Payin, prefill: [String: String]) -> any MethodSection
}

/// One sheet's fields for a `SheetMethod`. SwiftUI keeps the sheet through rotation and light, dark or text size
/// changes, so the section keeps what the payer typed itself.
@_spi(SynqtAddon)
@MainActor
public protocol MethodSection: AnyObject {
    /// Added to the sheet under "Your details".
    var view: AnyView { get }

    /// Checks every field when the payer taps Pay and shows each problem under its field. Returns the problems as
    /// (field label, message) for VoiceOver to read out; empty if all pass.
    func check() -> [(label: String, message: String)]

    /// The `paymentMethod` object to send, built after `check` passed. Throw `MethodSectionError` with payer-facing text
    /// if it can't be built; the sheet shows it and sends nothing. Other errors show as the sheet's own failures.
    func paymentMethod() async throws -> JSON

    /// Shows SYNQT's refusal under the field SYNQT names in `attr` and returns that field's label, or nil if no field
    /// here matches.
    func showError(attr: String, message: String) -> String?

    /// Wipes what the payer typed. Called when the sheet closes.
    func clear()
}

/// A `MethodSection` could not build its request. `payerMessage` is shown in the sheet as it is.
@_spi(SynqtAddon)
public struct MethodSectionError: Error, Equatable {
    public let payerMessage: String

    public init(_ payerMessage: String) { self.payerMessage = payerMessage }
}

/// Add-on methods, in the order they were added.
final class Addons: @unchecked Sendable { // every access holds the lock
    static let shared = Addons()
    private let lock = NSLock()
    private var methods: [any SheetMethod] = []

    var all: [any SheetMethod] { lock.lock(); defer { lock.unlock() }; return methods }

    func add(_ method: any SheetMethod) {
        lock.lock(); defer { lock.unlock() }
        methods.removeAll { $0.code == method.code }
        methods.append(method)
    }
}
