import WidgetKit
import SwiftUI

// MARK: - Timeline

struct DayEntry: TimelineEntry {
    let date: Date
    let groups: [ProjectGroup]
    let configured: Bool
}

struct DayProvider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), groups: DayProvider.sample, configured: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> Void) {
        // Render instantly from the shared snapshot, honoring snoozes.
        let groups = DayPlanner.plan(AppGroupStore.loadSnapshot(),
                                     snoozed: AppGroupStore.activeSnoozedIDs())
        completion(DayEntry(date: Date(),
                            groups: context.isPreview ? DayProvider.sample : groups,
                            configured: AppGroupStore.isConfigured))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DayEntry>) -> Void) {
        Task {
            var tasks = AppGroupStore.loadSnapshot()
            if let service = SupabaseService.fromStore() {
                if let fresh = try? await service.fetchDayTasks() {
                    tasks = fresh
                    AppGroupStore.saveSnapshot(fresh)
                }
            }
            let entry = DayEntry(date: Date(),
                                 groups: DayPlanner.plan(tasks, snoozed: AppGroupStore.activeSnoozedIDs()),
                                 configured: AppGroupStore.isConfigured)
            // Refresh roughly every 15 minutes; toggles/snoozes reload immediately.
            let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }

    static let sample: [ProjectGroup] = [
        ProjectGroup(name: "Merkle Science Product", tasks: [
            TaskItem(id: "1", name: "KYBB watchlist demo", status: "todo", dueDate: "2026-06-29", priority: "high", project: "Merkle Science Product"),
            TaskItem(id: "2", name: "Compass rule engine toggle", status: "in_progress", dueDate: "2026-06-30", priority: "urgent", project: "Merkle Science Product"),
        ]),
        ProjectGroup(name: "Proffy", tasks: [
            TaskItem(id: "3", name: "Footer for Proffy", status: "todo", dueDate: "2026-07-02", priority: "medium", project: "Proffy"),
        ]),
    ]
}

// MARK: - Widget

struct TaskflowWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TaskflowDayWidget", provider: DayProvider()) { entry in
            TaskflowWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Today & Upcoming")
        .description("Your todo / in-progress tasks due today or later, grouped by project.")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

// MARK: - Views

struct TaskflowWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: DayEntry

    private var rowBudget: Int {
        switch family {
        case .systemMedium: return 5
        case .systemLarge: return 12
        default: return 20
        }
    }

    var body: some View {
        if !entry.configured {
            unconfigured
        } else if entry.groups.isEmpty {
            allClear
        } else {
            list
        }
    }

    private var list: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Today & Upcoming").font(.headline)
                Spacer()
                Text("\(DayPlanner.openCount(entry.groups))")
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(rows) { row in
                    if row.showHeader {
                        Text(row.projectName)
                            .font(.caption2).fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                    WidgetTaskRow(task: row.task)
                }
            }
            Spacer(minLength: 0)

            if remaining(limit: rowBudget) > 0 {
                Text("+\(remaining(limit: rowBudget)) more")
                    .font(.caption2).foregroundStyle(.secondary)
            }
        }
    }

    /// One rendered widget line: a task, optionally preceded by its project header.
    private struct WidgetRow: Identifiable {
        let task: TaskItem
        let showHeader: Bool
        var id: String { task.id }
        var projectName: String { task.project?.isEmpty == false ? task.project! : "No project" }
    }

    private var rows: [WidgetRow] { flattened(limit: rowBudget) }

    /// Flatten groups into rows (first task of each project carries a header).
    private func flattened(limit: Int) -> [WidgetRow] {
        var out: [WidgetRow] = []
        for group in entry.groups {
            for (i, task) in group.tasks.enumerated() {
                if out.count >= limit { return out }
                out.append(WidgetRow(task: task, showHeader: i == 0))
            }
        }
        return out
    }

    private func remaining(limit: Int) -> Int {
        max(0, DayPlanner.openCount(entry.groups) - min(limit, DayPlanner.openCount(entry.groups)))
    }

    private var unconfigured: some View {
        VStack(spacing: 6) {
            Image(systemName: "link.badge.plus").font(.title)
            Text("Connect Taskflow").font(.headline)
            Text("Open the app and connect to Supabase.")
                .font(.caption).foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var allClear: some View {
        VStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle).foregroundStyle(.green)
            Text("All clear").font(.headline)
            Text("Nothing due today or later.").font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Interactive row — checkbox marks done, the moon button snoozes for today.
struct WidgetTaskRow: View {
    let task: TaskItem

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Button(intent: ToggleTaskIntent(taskID: task.id, done: true)) {
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            Text(task.name)
                .font(.callout)
                .lineLimit(1)

            Spacer(minLength: 4)

            Text(task.dueLabel)
                .font(.caption2)
                .foregroundStyle(task.isDueToday() ? Color.orange : Color.secondary)

            Button(intent: SnoozeTaskIntent(taskID: task.id)) {
                Image(systemName: "moon.zzz.fill")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .buttonStyle(.plain)
        }
    }
}
