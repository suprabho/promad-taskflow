import Foundation
import SwiftUI
import WidgetKit

/// Observable view-model backing the menu bar popover. Fetches the day's tasks,
/// groups them, persists a snapshot for the widget, and handles check-offs with
/// optimistic UI.
@MainActor
final class DayStore: ObservableObject {
    @Published var groups: [ProjectGroup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    private var allTasks: [TaskItem] = []

    var isConfigured: Bool { AppGroupStore.isConfigured }
    var openCount: Int { DayPlanner.openCount(groups) }

    init() {
        // Show the cached snapshot immediately, then refresh.
        allTasks = AppGroupStore.loadSnapshot()
        groups = DayPlanner.plan(allTasks)
    }

    func refresh() async {
        guard let service = SupabaseService.fromStore() else {
            errorMessage = nil
            groups = []
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let tasks = try await service.fetchDayTasks()
            allTasks = tasks
            groups = DayPlanner.plan(tasks)
            lastUpdated = Date()
            AppGroupStore.saveSnapshot(tasks)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Check a task off (or back on) with an optimistic local update.
    func toggle(_ task: TaskItem) async {
        guard let service = SupabaseService.fromStore() else { return }
        let markDone = !task.isDone

        // Optimistic: remove from view (done) immediately.
        if markDone {
            allTasks.removeAll { $0.id == task.id }
        } else if let i = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks[i].status = "todo"
        }
        groups = DayPlanner.plan(allTasks)

        do {
            try await service.setDone(taskID: task.id, done: markDone)
            AppGroupStore.saveSnapshot(allTasks)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            // Roll back by refetching the truth.
            errorMessage = error.localizedDescription
            await refresh()
        }
    }
}
