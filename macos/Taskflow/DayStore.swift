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

    // For the new-task form.
    @Published var users: [TaskUser] = []
    @Published var projects: [String] = []

    private var allTasks: [TaskItem] = []

    var isConfigured: Bool { AppGroupStore.isConfigured }
    var openCount: Int { DayPlanner.openCount(groups) }

    init() {
        // Show the cached snapshot immediately, then refresh.
        allTasks = AppGroupStore.loadSnapshot()
        replan()
    }

    /// Re-group from the current tasks, applying the active snoozes.
    private func replan() {
        groups = DayPlanner.plan(allTasks, snoozed: AppGroupStore.activeSnoozedIDs())
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
            replan()
            lastUpdated = Date()
            AppGroupStore.saveSnapshot(tasks)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Load users + project suggestions for the new-task form (best effort).
    func loadFormData() async {
        guard let service = SupabaseService.fromStore() else { return }
        async let u = service.fetchUsers()
        async let p = service.fetchProjects()
        if let users = try? await u { self.users = users }
        if let projects = try? await p { self.projects = projects }
    }

    /// Create a task, then refresh. Returns true on success.
    func createTask(name: String, status: String, priority: String,
                    project: String?, dueDate: String?, assignees: [String]) async -> Bool {
        guard let service = SupabaseService.fromStore() else {
            errorMessage = "Connect to Supabase first."
            return false
        }
        do {
            try await service.createTask(name: name, status: status, priority: priority,
                                         project: project, dueDate: dueDate, assignees: assignees)
            await refresh()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    /// Snooze a task for the rest of the day (local only).
    func snooze(_ task: TaskItem) {
        AppGroupStore.snooze(taskID: task.id)
        replan()
        WidgetCenter.shared.reloadAllTimelines()
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
        replan()

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
