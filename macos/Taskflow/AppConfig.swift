import Foundation

/// Central place to resolve which URL the app loads and a few tunables.
///
/// Resolution order for the site URL (first non-empty wins):
///   1. `TASKFLOW_URL` environment variable (handy for `xcodebuild` / Xcode scheme env).
///   2. A user override saved at runtime (Cmd-L → "Set Server URL…"), stored in UserDefaults.
///   3. The `TaskflowURL` key in Info.plist (the value baked into the build).
///   4. `defaultURL` below as a final fallback.
enum AppConfig {
    /// Change this (or the `TaskflowURL` Info.plist key) to your deployed site.
    /// Example: "https://taskflow.promad.design"
    static let defaultURL = "https://taskflow.promad.design"

    static let userDefaultsURLKey = "TaskflowServerURLOverride"

    /// A desktop-Safari user agent. Google's OAuth consent screen rejects
    /// the default WKWebView user agent ("disallowed_useragent"); presenting
    /// a normal Safari UA lets "Continue with Google" complete inside the app.
    static let userAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " +
        "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15"

    static func resolvedURL() -> URL {
        let candidates: [String?] = [
            ProcessInfo.processInfo.environment["TASKFLOW_URL"],
            UserDefaults.standard.string(forKey: userDefaultsURLKey),
            Bundle.main.object(forInfoDictionaryKey: "TaskflowURL") as? String,
            defaultURL,
        ]

        for case let raw? in candidates {
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty, let url = normalize(trimmed) {
                return url
            }
        }
        // Should never happen given defaultURL, but keep the type total.
        return URL(string: "https://example.com")!
    }

    static func saveUserURL(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        UserDefaults.standard.set(trimmed, forKey: userDefaultsURLKey)
    }

    /// Adds an https:// scheme if the user typed a bare host.
    private static func normalize(_ raw: String) -> URL? {
        if raw.contains("://") { return URL(string: raw) }
        return URL(string: "https://\(raw)")
    }

    /// Whether `url` belongs to the app's own site (used to decide whether a
    /// navigation stays in-app or opens in the system browser).
    static func isInternal(_ url: URL, relativeTo home: URL) -> Bool {
        guard let host = url.host?.lowercased(),
              let homeHost = home.host?.lowercased() else { return false }
        if host == homeHost { return true }
        // Treat localhost variations as internal during local development.
        let localHosts: Set<String> = ["localhost", "127.0.0.1", "0.0.0.0"]
        return localHosts.contains(host) && localHosts.contains(homeHost)
    }

    /// Hosts we always keep inside the webview because they're part of the
    /// auth round-trip (Supabase + Google sign-in), even though they aren't
    /// the app's own origin.
    static func isAuthFlow(_ url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        let authSuffixes = [
            "supabase.co",
            "supabase.in",
            "accounts.google.com",
            "google.com",
            "gstatic.com",
            "googleapis.com",
        ]
        return authSuffixes.contains { host == $0 || host.hasSuffix("." + $0) }
    }
}
