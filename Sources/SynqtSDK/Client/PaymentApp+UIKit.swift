import Foundation

/// True when `url` is the return URL, whatever query the Payment Web App added; a longer path is not.
func isReturn(_ url: URL, to returnURL: URL) -> Bool {
    url.scheme == returnURL.scheme && url.host == returnURL.host && url.port == returnURL.port && url.path == returnURL.path
}

#if canImport(UIKit)
import UIKit
import WebKit

/// How the Payment Web App closed. Either way, ask `IncomingPaymentsApi.getPayin` where the payment stands.
public enum PaymentAppResult: Equatable, Sendable {
    /// The Payment Web App sent the payer to `returnURL`, with whatever it added to it.
    case returned(URL)
    /// The payer closed it first.
    case closed
}

extension PayinCheckout {
    /**
     Shows SYNQT's hosted Payment Web App inside the app, over `viewController`, and returns once the payer reaches
     `returnURL` or closes it. `onPresented` runs once it is on screen. Links to other apps (bank apps, UPI) open
     outside it, as do https links a bank app claims as universal links. Cancelling the calling task closes it and
     returns `.closed`. Returns `.closed` straight away, showing nothing, if `viewController` is not in a window or is
     already presenting something, as UIKit would refuse to present it. `paymentMethodCode`, `prefill` and `extra` are
     as for `paymentAppURL`.
     */
    @MainActor
    public func presentPaymentApp(from viewController: UIViewController, merchantCode: String,
                                  paymentMethodCode: String? = nil, prefill: KeyValuePairs<String, String> = [:],
                                  extra: KeyValuePairs<String, String> = [:],
                                  onPresented: @escaping @MainActor () -> Void = {}) async -> PaymentAppResult {
        guard let url = URL(string: paymentAppURL(merchantCode: merchantCode, paymentMethodCode: paymentMethodCode, prefill: prefill, extra: extra)), let back = URL(string: returnURL) else {
            return .closed
        }
        return await PaymentAppController(url: url, returnURL: back).present(from: viewController, onPresented: onPresented)
    }
}

private final class PaymentAppController: UIViewController, WKNavigationDelegate {
    private let url: URL
    private let returnURL: URL
    private var done: ((PaymentAppResult) -> Void)?

    init(url: URL, returnURL: URL) {
        self.url = url
        self.returnURL = returnURL
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("not used") }

    override func loadView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        // Lets the payer swipe back through the web app's pages; the bar keeps only Close.
        webView.allowsBackForwardNavigationGestures = true
        // A web view is opaque white by default, which shows around the page (under the bar, on overscroll) in dark mode.
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        webView.scrollView.backgroundColor = .systemBackground
        webView.load(URLRequest(url: url))
        view = webView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: text("synqt_sheet_close"), primaryAction: UIAction { [weak self] _ in
            self?.finish(.closed)
        })
    }

    func present(from presenter: UIViewController, onPresented: @escaping @MainActor () -> Void) async -> PaymentAppResult {
        // UIKit refuses these without calling the completion, which would leave the caller waiting for ever.
        guard presenter.viewIfLoaded?.window != nil, presenter.presentedViewController == nil else { return .closed }
        return await withTaskCancellationHandler {
            await withCheckedContinuation { (resume: CheckedContinuation<PaymentAppResult, Never>) in
                done = { resume.resume(returning: $0) }
                let navigation = UINavigationController(rootViewController: self)
                // A whole web checkout, so it gets the whole screen; that also leaves Close as the only way out.
                navigation.modalPresentationStyle = .fullScreen
                // UIKit crashes restoring a keyboard whose owner is gone, so no keyboard crosses the transition either way.
                presenter.view.window?.endEditing(true)
                presenter.present(navigation, animated: true) { onPresented() }
            }
        } onCancel: {
            Task { @MainActor [weak self] in self?.finish(.closed) }
        }
    }

    private func finish(_ result: PaymentAppResult) {
        guard let done else { return }
        self.done = nil
        view.endEditing(true)
        navigationController?.dismiss(animated: true)
        done(result)
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction) async -> WKNavigationActionPolicy {
        guard let target = action.request.url else { return .cancel }
        if isReturn(target, to: returnURL) {
            finish(.returned(target))
            return .cancel
        }
        // A bank's https link opens its app when one claims it as a universal link; otherwise it stays in here.
        if target.scheme == "https", action.targetFrame?.isMainFrame == true, target.host != url.host,
           await UIApplication.shared.open(target, options: [.universalLinksOnly: true]) {
            return .cancel
        }
        if target.scheme == "https" || target.scheme == "http" || target.scheme == "about" { return .allow }
        await UIApplication.shared.open(target)
        return .cancel
    }
}
#endif
