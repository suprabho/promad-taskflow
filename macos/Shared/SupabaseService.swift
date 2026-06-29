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
        comps.percentEncodedQuery = query
        var req = URLRequest(url: comps.url!)
        req.setValue(anonKey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }

    /// Fetch open tasks due today or earlier for the configured workspace.
    /// Filtering happens server-side; `DayPlanner` does the grouping.
    func fetchDayTasks() async throws -> [TaskItem] {
        let today = TaskflowDate.todayISO()
        // status != done, due_date <= today (PostgREST drops nulls for lte),
        // limited to the workspace, newest-relevant first.
        let query = [
            "select=id,name,status,due_date,priority,project,workspace_id",
            "workspace_id=eq.\(workspaceID)",
            "status=neq.done",
            "due_date=lte.\(today)",
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
