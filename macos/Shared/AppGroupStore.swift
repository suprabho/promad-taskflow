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
    private static let kSnoozes = "snoozeUntil"

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

    // MARK: Snooze ("hide for the rest of today")

    /// taskID -> expiry (seconds since 1970). Expiry is the start of tomorrow,
    /// so a snooze naturally lapses at local midnight.
    private static func snoozeMap() -> [String: Double] {
        (defaults.dictionary(forKey: kSnoozes) as? [String: Double]) ?? [:]
    }

    private static func writeSnoozeMap(_ map: [String: Double]) {
        defaults.set(map, forKey: kSnoozes)
    }

    /// Snooze a task until the next local midnight.
    static func snooze(taskID: String, now: Date = Date()) {
        let startOfTomorrow = Calendar.current.date(
            byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: now)
        ) ?? now.addingTimeInterval(86_400)
        var map = snoozeMap()
        map[taskID] = startOfTomorrow.timeIntervalSince1970
        writeSnoozeMap(map)
    }

    static func unsnooze(taskID: String) {
        var map = snoozeMap()
        map.removeValue(forKey: taskID)
        writeSnoozeMap(map)
    }

    /// IDs still snoozed right now. Prunes any that have lapsed as a side effect.
    static func activeSnoozedIDs(now: Date = Date()) -> Set<String> {
        let cutoff = now.timeIntervalSince1970
        var map = snoozeMap()
        let expired = map.filter { $0.value <= cutoff }.map(\.key)
        if !expired.isEmpty {
            for id in expired { map.removeValue(forKey: id) }
            writeSnoozeMap(map)
        }
        return Set(map.keys)
    }
}
