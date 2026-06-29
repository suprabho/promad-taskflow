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

    /// Overdue = has a due date strictly before today and not done.
    func isOverdue(now: Date = Date()) -> Bool {
        guard let due, !isDone else { return false }
        return Calendar.current.startOfDay(for: due) < Calendar.current.startOfDay(for: now)
    }

    func isDueToday(now: Date = Date()) -> Bool {
        guard let due else { return false }
        return Calendar.current.isDate(due, inSameDayAs: now)
    }
}

/// Tasks for one project, ready to render as a card/section.
struct ProjectGroup: Identifiable, Hashable {
    let name: String            // display name ("No project" when unset)
    var tasks: [TaskItem]
    var id: String { name }
}

enum TaskflowDate {
    /// Postgres `date` columns arrive as "yyyy-MM-dd". Parse at noon UTC to
    /// dodge timezone day-rollover surprises, then compare by calendar day.
    static func parseISODate(_ s: String) -> Date? {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: String(s.prefix(10)))
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
/// so they always agree on what "today & overdue" means.
enum DayPlanner {
    /// Keep only open (not done) tasks due today or earlier, grouped by
    /// project, overdue first, then by due date and priority.
    static func plan(_ tasks: [TaskItem], now: Date = Date()) -> [ProjectGroup] {
        let relevant = tasks.filter { t in
            guard !t.isDone else { return false }
            return t.isOverdue(now: now) || t.isDueToday(now: now)
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
            // Projects with overdue work float to the top, then alphabetical.
            .sorted { lhs, rhs in
                let lo = lhs.tasks.contains { $0.isOverdue(now: now) }
                let ro = rhs.tasks.contains { $0.isOverdue(now: now) }
                if lo != ro { return lo && !ro }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    static func openCount(_ groups: [ProjectGroup]) -> Int {
        groups.reduce(0) { $0 + $1.tasks.count }
    }
}
