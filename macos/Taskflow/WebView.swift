import SwiftUI
import WebKit
import AppKit

/// Observable state shared between the SwiftUI chrome and the underlying
/// WKWebView so toolbar buttons / menu items can drive navigation.
final class WebViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var title = "Taskflow"
    @Published var loadError: String?

    /// Set by the Coordinator once the WKWebView exists.
    fileprivate weak var webView: WKWebView?

    /// Always reflects the current configured/overridden URL.
    var home: URL { AppConfig.resolvedURL() }

    func reload() {
        loadError = nil
        if webView?.url == nil {
            loadHome()
        } else {
            webView?.reload()
        }
    }

    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }

    func loadHome() {
        loadError = nil
        webView?.load(URLRequest(url: home))
    }
}

/// Bridges WKWebView into SwiftUI.
struct WebView: NSViewRepresentable {
    @ObservedObject var model: WebViewModel

    func makeCoordinator() -> Coordinator { Coordinator(model: model) }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        // Persistent store keeps the Supabase session cookie across launches.
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = AppConfig.userAgent
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        // Match the app window background so there's no white overscroll flash.
        webView.underPageBackgroundColor = .windowBackgroundColor

        model.webView = webView
        webView.load(URLRequest(url: model.home))
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let model: WebViewModel

        init(model: WebViewModel) { self.model = model }

        private func sync(_ webView: WKWebView) {
            model.canGoBack = webView.canGoBack
            model.canGoForward = webView.canGoForward
            if let title = webView.title, !title.isEmpty {
                model.title = title
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            model.isLoading = true
            model.loadError = nil
            sync(webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            model.isLoading = false
            sync(webView)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            model.isLoading = false
            report(error)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            model.isLoading = false
            report(error)
        }

        private func report(_ error: Error) {
            let nsError = error as NSError
            // -999 = NSURLErrorCancelled, fired on normal redirects; ignore.
            guard nsError.code != NSURLErrorCancelled else { return }
            model.loadError = nsError.localizedDescription
        }

        /// Decide whether a navigation stays in-app or opens in the browser.
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // Keep mailto/tel and other non-web schemes out of the webview.
            if let scheme = url.scheme?.lowercased(),
               scheme != "http", scheme != "https", scheme != "about", scheme != "blob", scheme != "data" {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
                return
            }

            let staysInApp = AppConfig.isInternal(url, relativeTo: model.home)
                || AppConfig.isAuthFlow(url)

            // External links the user explicitly clicked → system browser.
            if !staysInApp, navigationAction.navigationType == .linkActivated {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        /// Handle `target="_blank"` / window.open by loading in the same view
        /// (so OAuth popups don't get lost), or the system browser if external.
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                if AppConfig.isInternal(url, relativeTo: model.home) || AppConfig.isAuthFlow(url) {
                    webView.load(navigationAction.request)
                } else {
                    NSWorkspace.shared.open(url)
                }
            }
            return nil
        }
    }
}
