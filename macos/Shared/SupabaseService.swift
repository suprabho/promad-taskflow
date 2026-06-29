import Foundation

/// Minimal Supabase REST (PostgREST) client for the native surfaces.
/// Reads/writes the `tasks` table using the public anon key. Your RLS allows
/// `select` and `update` for everyone, so no auth session is required.
struct SupabaseService {
    enum ServiceError: LocalizedError {
        case notConfigured
        case badResponse(Int, String)
        case decoding(String)

        var errorDescription: String? {
            switch self {
            case .notConfigured:
                return "Supabase isn’t connected yet. Open the menu bar and choose “Connect to Supabase…”."
            case let .badResponse(code, body):
                return "Supabase returned \(code). \(body)"
            case let .decoding(msg):
                return "Couldn’t read the response: \(msg)"
            }
        }
    }

    let baseURL: String
    let anonKey: String
    let workspaceID: String

    /// Build from the shared App Group config; nil if not configured.
    static func fromStore() -> SupabaseService? {
        guard let url = AppGroupStore.supabaseURL,
              let key = AppGroupStore.supabaseAnonKey,
              !url.isEmpty, !key.isEmpty else { return nil }
        return SupabaseService(baseURL: url, anonKey: key, workspaceID: AppGroupStore.workspaceID)
    }

    private func request(path: String, query: String) -> URLRequest {
        var comps = URLComponents(string: "\(baseURL)/rest/v1/\(path)")!
        if !query.isEmpty { comps.percentEncodedQuery = query }
        var req = URLRequest(url: comps.url!)
        req.setValue(anonKey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }

    /// Fetch actionable (todo / in progress) tasks due today or later for the
    /// configured workspace. Filtering happens server-side; `DayPlanner` groups
    /// and applies the local snooze.
    func fetchDayTasks() async throws -> [TaskItem] {
        let today = TaskflowDate.todayISO()
        // status in (todo, in_progress), due_date >= today (PostgREST drops
        // nulls for gte), limited to the workspace, soonest-due first.
        let query = [
            "select=id,name,status,due_date,priority,project,workspace_id",
            "workspace_id=eq.\(workspaceID)",
            "status=in.(todo,in_progress)",
            "due_date=gte.\(today)",
            "order=due_date.asc",
            "limit=500",
        ].joined(separator: "&")

        var req = request(path: "tasks", query: query)
        req.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: req)
        try Self.check(response, data)
        do {
            return try JSONDecoder().decode([TaskItem].self, from: data)
        } catch {
            throw ServiceError.decoding(error.localizedDescription)
        }
    }

    /// Workspace members, for the assignee picker.
    func fetchUsers() async throws -> [TaskUser] {
        var req = request(path: "users", query: "select=id,name&order=name.asc")
        req.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: req)
        try Self.check(response, data)
        return (try? JSONDecoder().decode([TaskUser].self, from: data)) ?? []
    }

    /// Distinct project names in the workspace, for the project suggestions.
    func fetchProjects() async throws -> [String] {
        let query = [
            "select=project",
            "workspace_id=eq.\(workspaceID)",
            "project=not.is.null",
            "limit=2000",
        ].joined(separator: "&")
        var req = request(path: "tasks", query: query)
        req.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: req)
        try Self.check(response, data)
        struct Row: Decodable { let project: String? }
        let rows = (try? JSONDecoder().decode([Row].self, from: data)) ?? []
        let names = Set(rows.compactMap { $0.project }.filter { !$0.isEmpty })
        return names.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    /// Insert a new task. Nil/empty optional fields fall back to DB defaults.
    func createTask(name: String,
                    status: String,
                    priority: String,
                    project: String?,
                    dueDate: String?,
                    assignees: [String]) async throws {
        var body: [String: Any] = [
            "name": name,
            "status": status,
            "priority": priority,
            "assignees": assignees,
            "workspace_id": workspaceID,
        ]
        if let project, !project.isEmpty { body["project"] = project }
        if let dueDate, !dueDate.isEmpty { body["due_date"] = dueDate }

        var req = request(path: "tasks", query: "")
        req.httpMethod = "POST"
        req.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: req)
        try Self.check(response, data)
    }

    /// Flip a task to done (or back to todo). Returns the new status.
    @discardableResult
    func setDone(taskID: String, done: Bool) async throws -> String {
        let newStatus = done ? "done" : "todo"
        var req = request(path: "tasks", query: "id=eq.\(taskID)")
        req.httpMethod = "PATCH"
        req.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        req.httpBody = try JSONSerialization.data(withJSONObject: ["status": newStatus])

        let (data, response) = try await URLSession.shared.data(for: req)
        try Self.check(response, data)
        return newStatus
    }

    private static func check(_ response: URLResponse, _ data: Data) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw ServiceError.badResponse(http.statusCode, body)
        }
    }
}
