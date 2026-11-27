#if canImport(UIKit)
import SwiftUI
import UIKit

extension Payin {
    /**
     Collects the payer's details for `paymentMethodCode` (one of `Synqt.directPaymentMethods`) in a Synqt-branded sheet
     over `viewController`, then creates the payin as `create` does. Errors, including SYNQT's field errors, stay in the
     sheet so the payer can correct them. Returns nil if the payer closes it; cancelling the calling task closes it too.

     The bank or provider field lists the banks `availablePaymentOptions` returns for this payin and
     `paymentMethodCode` (PAYIN_CREATE allows that call); an optional one is hidden when SYNQT lists none. The summary
     names the merchant when the token also allows `GET /merchant-info`. `prefill` is keyed by field path, such as
     `emailAddress` or `customerName.lastName`. CARD is offered only with SYNQT's card add-on, for PCI DSS compliant
     merchants.

     `onPresented` runs once the sheet is on screen, and `onPaymentStarted` each time a payment is sent to SYNQT (the
     details passed the sheet's checks; SYNQT may still refuse them, and then there may be no payin). The call returns
     once the sheet has closed.

     Returns nil straight away, showing nothing, if `viewController` is not in a window or is already presenting
     something, as UIKit would refuse to present the sheet.

     Throws `SynqtArgumentError` only for a `paymentMethodCode` the sheet does not support.
     */
    @MainActor
    public func presentPaymentSheet(from viewController: UIViewController, paymentMethodCode: String,
                                    prefill: [String: String] = [:], customerIP: String? = nil,
                                    onPresented: @escaping @MainActor () -> Void = {},
                                    onPaymentStarted: @escaping @MainActor () -> Void = {}) async throws -> CreatePayinResult? {
        let method = Addons.shared.all.first { $0.code == paymentMethodCode }
        // An add-on's method draws its own fields, so the sheet gets an empty form, named in the payer's language already.
        guard let form = methodForms.first(where: { $0.code == paymentMethodCode })
            ?? method.map({ sheetMethod in MethodForm(sheetMethod.code, sheetMethod.name, []) { _ in throw SynqtArgumentError("built by the add-on") } }) else {
            throw SynqtArgumentError("Unknown paymentMethodCode \(paymentMethodCode)")
        }
        let (operators, merchant) = await sheetContext(for: form)
        let summary = PaymentSummary(amount: money.description, merchant: merchant, method: text(form.name), reference: id)
        let addon = method.map { sheetMethod in
            SheetAddon(section: sheetMethod.section(payin: self, prefill: prefill), secure: sheetMethod.secure) { try await self.create($0, customerIP: customerIP) }
        }
        let model = PaymentSheetModel(form: form, prefill: prefill, operators: operators, summary: summary, addon: addon) { method in
            try await self.create(method, customerIP: customerIP)
        }
        model.onPaymentStarted = onPaymentStarted
        model.reloadOperators = { await self.sheetOperators(for: form) }
        return await PaymentSheetController(model: model).present(from: viewController, onPresented: onPresented)
    }

    /// Opens `paymentAppURL` in Safari and returns once Safari has it, not when the payer is done: the payer comes
    /// back through `returnURL`, which must then be a universal link your app handles. To know when they are done in
    /// the app itself, use `presentPaymentApp`.
    @MainActor
    @discardableResult
    public func openPaymentApp(merchantCode: String, paymentMethodCode: String? = nil,
                               prefill: KeyValuePairs<String, String> = [:],
                               extra: KeyValuePairs<String, String> = [:]) async -> Bool {
        guard let url = URL(string: paymentAppURL(merchantCode: merchantCode, paymentMethodCode: paymentMethodCode,
                                                  prefill: prefill, extra: extra)) else { return false }
        return await UIApplication.shared.open(url)
    }
}

/// Hosts the sheet as a form sheet and returns its result once, however it closes.
private final class PaymentSheetController: UIHostingController<PaymentSheetView> {
    private let model: PaymentSheetModel

    init(model: PaymentSheetModel) {
        self.model = model
        super.init(rootView: PaymentSheetView(model: model))
        let code = model.form.code
        model.copy = { UIPasteboard.general.string = $0 }
        model.announce = { UIAccessibility.post(notification: .announcement, argument: $0) }
        // The iPad's centred card grows to fit the form instead of its fixed default size; UIKit keeps it on screen, and a
        // phone's sheet ignores it.
        model.fitHeight = { [weak self] height in
            guard let self, view.bounds.width > 0 else { return }
            preferredContentSize = CGSize(width: view.bounds.width, height: height.rounded(.up)) // a zero width is ignored
        }
        // Only the close button closes it: no tap outside, and no swipe down, as iOS can't block one without the other.
        isModalInPresentation = true
        model.openLink = { link in
            guard let url = URL(string: link) else { return false }
            return await UIApplication.shared.open(url)
        }
        // A universal link opens the method's app only if it is installed; otherwise try the app's own scheme.
        model.openInApp = { link in
            for candidate in appLinks(link, appSchemes[code]) {
                guard let url = URL(string: candidate) else { continue }
                let universal = candidate.hasPrefix("https://")
                if await UIApplication.shared.open(url, options: universal ? [.universalLinksOnly: true] : [:]) { return true }
            }
            return false
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("not used") }

    func present(from presenter: UIViewController, onPresented: @escaping @MainActor () -> Void) async -> CreatePayinResult? {
        // UIKit refuses these without calling the completion, which would leave the caller waiting for ever.
        guard presenter.viewIfLoaded?.window != nil, presenter.presentedViewController == nil else { return nil }
        return await withTaskCancellationHandler {
            await withCheckedContinuation { (done: CheckedContinuation<CreatePayinResult?, Never>) in
                let stopFollowing = followPhoneStyle(scene: presenter.view.window?.windowScene)
                let stopConcealing = model.addon?.secure == true ? conceal() : {}
                model.onFinish = { [weak self] result in
                    stopFollowing()
                    stopConcealing()
                    if let self, self.presentingViewController != nil { self.dismiss(animated: true) }
                    done.resume(returning: result)
                }
                // Apple's style for a short form: a bottom sheet on phones, a centred card on iPad and the opened iPhone Duo.
                modalPresentationStyle = .formSheet
                presenter.present(self, animated: true) { [model] in
                    onPresented()
                    model.start()
                }
            }
        } onCancel: { [model] in
            Task { @MainActor in model.finish(nil) }
        }
    }

    private var inactive = false
    private lazy var cover: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    /**
     For an add-on method marked secure, such as CARD: covers the sheet while the app is inactive, so the app switcher's
     snapshot shows no card details, and while the screen is recorded, mirrored or sent over AirPlay. iOS gives apps no
     way to block a screenshot. Returns how to stop.
     */
    private func conceal() -> () -> Void {
        let center = NotificationCenter.default
        let observers = [
            center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
                MainActor.assumeIsolated { self?.inactive = true; self?.updateCover() }
            },
            center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
                MainActor.assumeIsolated { self?.inactive = false; self?.updateCover() }
            },
            center.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
                MainActor.assumeIsolated { self?.updateCover() }
            },
        ]
        updateCover()
        return { observers.forEach(center.removeObserver) }
    }

    private func updateCover() {
        // shortcut: UIScreen.main.isCaptured is deprecated from iOS 18 for the scene's sceneCaptureState; switch once the SDK needs iOS 17.
        guard inactive || UIScreen.main.isCaptured else { return cover.removeFromSuperview() }
        cover.backgroundColor = UIColor(SynqtColors.for(traitCollection.userInterfaceStyle == .dark ? .dark : .light).surface)
        cover.frame = view.bounds
        view.addSubview(cover) // added in UIKit, not SwiftUI state, so it is on screen before the snapshot is taken
    }

    /**
     The sheet follows the phone's light or dark setting, also while it is open, even when the host app forces its own
     on its window: the window scene and the screen carry the phone's setting, not the window's. Returns how to stop.
     */
    private func followPhoneStyle(scene: UIWindowScene?) -> () -> Void {
        if #available(iOS 17, *), let scene {
            overrideUserInterfaceStyle = scene.traitCollection.userInterfaceStyle
            let registration = scene.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (scene: UIWindowScene, _) in
                self?.overrideUserInterfaceStyle = scene.traitCollection.userInterfaceStyle
            }
            return { scene.unregisterForTraitChanges(registration) }
        }
        // shortcut: iOS 15 and 16 have no change signal outside the app's own (possibly forced) style, so the setting is
        // read again when the app becomes active, which covers Control Center and Settings but not an automatic switch
        // while the sheet is open; drop this branch once the SDK needs iOS 17.
        let update: @MainActor @Sendable () -> Void = { [weak self] in self?.overrideUserInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle }
        update()
        let observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in MainActor.assumeIsolated { update() } }
        return { NotificationCenter.default.removeObserver(observer) }
    }
}
#endif
