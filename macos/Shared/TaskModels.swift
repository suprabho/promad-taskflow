import Foundation

/// A single task row, trimmed to the fields the native surfaces need.
struct TaskItem: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var status: String          // todo | in_progress | review | done | paused
    var dueDate: String?        // ISO "yyyy-MM-dd" (Postgres date), may be nil
    var priority: String        // low | medium | high | urgent
    var project: String?

    enum CodingKeys: String, CodingKey {
        case id, name, status, priority, project
        case dueDate = "due_date"
    }

    var isDone: Bool { status == "done" }

    /// Parsed due date in the user's calendar (date-only).
    var due: Date? {
        guard let dueDate else { return nil }
        return TaskflowDate.parseISODate(dueDate)
    }

    /// Statuses that belong in the day view.
    var isActionable: Bool { status == "todo" || status == "in_progress" }

    /// Eligible for the "Today & Upcoming" view: actionable, has a due date,
    /// and that date is today or later (overdue tasks are intentionally hidden).
    func isUpcoming(now: Date = Date()) -> Bool {
        guard isActionable, let due else { return false }
        let cal = Calendar.current
        return cal.startOfDay(for: due) >= cal.startOfDay(for: now)
    }

    func isDueToday(now: Date = Date()) -> Bool {
        guard let due else { return false }
        return Calendar.current.isDate(due, inSameDayAs: now)
    }

    func isDueTomorrow(now: Date = Date()) -> Bool {
        guard let due, let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) else { return false }
        return Calendar.current.isDate(due, inSameDayAs: tomorrow)
    }

    /// Short human label for the due date: "Today" / "Tomorrow" / "Jul 3".
    var dueLabel: String {
        guard let due else { return "" }
        if isDueToday() { return "Today" }
        if isDueTomorrow() { return "Tomorrow" }
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d"
        return f.string(from: due)
    }
}

/// Tasks for one project, ready to render as a card/section.
struct ProjectGroup: Identifiable, Hashable {
    let name: String            // display name ("No project" when unset)
    var tasks: [TaskItem]
    var id: String { name }
}

enum TaskflowDate {
    /// Postgres `date` columns arrive as "yyyy-MM-dd". These are calendar dates
    /// with no timezone, so parse them in the user's *local* calendar at noon —
    /// local so "today/tomorrow" comparisons are right everywhere, noon to dodge
    /// DST midnight gaps.
    static func parseISODate(_ s: String) -> Date? {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return f.date(from: String(s.prefix(10)) + "T12:00")
    }

    static func todayISO(now: Date = Date()) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: now)
    }
}

/// Pure grouping/sorting used by both the menu bar popover and the widget,
/// so they always agree on what "Today & Upcoming" means.
enum DayPlanner {
    /// Keep actionable (todo / in progress) tasks due today or later, excluding
    /// any the user has snoozed for the day. Grouped by project, soonest-due
    /// project first, then by due date and priority within each group.
    static func plan(_ tasks: [TaskItem], now: Date = Date(), snoozed: Set<String> = []) -> [ProjectGroup] {
        let relevant = tasks.filter { t in
            t.isUpcoming(now: now) && !snoozed.contains(t.id)
        }

        let priorityRank = ["urgent": 0, "high": 1, "medium": 2, "low": 3]

        let byProject = Dictionary(grouping: relevant) { $0.project?.isEmpty == false ? $0.project! : "No project" }

        return byProject
            .map { name, items in
                let sorted = items.sorted { a, b in
                    let ad = a.due ?? .distantFuture
                    let bd = b.due ?? .distantFuture
                    if ad != bd { return ad < bd }
                    return (priorityRank[a.priority] ?? 9) < (priorityRank[b.priority] ?? 9)
                }
                return ProjectGroup(name: name, tasks: sorted)
            }
            // Soonest-due project first; ties broken alphabetically.
            .sorted { lhs, rhs in
                let le = lhs.tasks.first?.due ?? .distantFuture
                let re = rhs.tasks.first?.due ?? .distantFuture
                if le != re { return le < re }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    static func openCount(_ groups: [ProjectGroup]) -> Int {
        groups.reduce(0) { $0 + $1.tasks.count }
    }
}
