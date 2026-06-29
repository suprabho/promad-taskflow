import Foundation

/// Shared configuration + a small task cache, stored in the App Group so the
/// main app and the widget extension see the same Supabase credentials and the
/// same last-known task snapshot.
enum AppGroupStore {
    /// Must match the App Group entitlement on BOTH targets.
    static let suiteName = "group.design.promad.taskflow"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    // MARK: Supabase credentials

    private static let kURL = "supabaseURL"
    private static let kAnonKey = "supabaseAnonKey"
    private static let kWorkspace = "workspaceID"
    private static let kSnapshot = "taskSnapshot"

    static var supabaseURL: String? {
        get { defaults.string(forKey: kURL) }
        set { defaults.set(newValue, forKey: kURL) }
    }

    static var supabaseAnonKey: String? {
        get { defaults.string(forKey: kAnonKey) }
        set { defaults.set(newValue, forKey: kAnonKey) }
    }

    /// Defaults to the seed workspace used by the web app.
    static var workspaceID: String {
        get { defaults.string(forKey: kWorkspace) ?? "ws-1" }
        set { defaults.set(newValue, forKey: kWorkspace) }
    }

    static var isConfigured: Bool {
        guard let u = supabaseURL, let k = supabaseAnonKey else { return false }
        return !u.trimmingCharacters(in: .whitespaces).isEmpty
            && !k.trimmingCharacters(in: .whitespaces).isEmpty
    }

    static func saveCredentials(url: String, anonKey: String, workspace: String?) {
        var u = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if u.hasSuffix("/") { u.removeLast() }
        supabaseURL = u
        supabaseAnonKey = anonKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if let workspace, !workspace.trimmingCharacters(in: .whitespaces).isEmpty {
            workspaceID = workspace.trimmingCharacters(in: .whitespaces)
        }
    }

    // MARK: Task snapshot (so the widget can render instantly + offline)

    static func saveSnapshot(_ tasks: [TaskItem]) {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        defaults.set(data, forKey: kSnapshot)
    }

    static func loadSnapshot() -> [TaskItem] {
        guard let data = defaults.data(forKey: kSnapshot),
              let tasks = try? JSONDecoder().decode([TaskItem].self, from: data) else { return [] }
        return tasks
    }
}
