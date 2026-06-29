import AppIntents
import WidgetKit

/// Toggles a task's done state. Used by the interactive widget checkbox
/// (Button(intent:)) and available to the app. Runs the Supabase write, then
/// refreshes any widgets so the UI reflects the new state.
@available(macOS 14.0, *)
struct ToggleTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task Done"
    static var description = IntentDescription("Mark a Taskflow task done or not done.")

    @Parameter(title: "Task ID")
    var taskID: String

    @Parameter(title: "Done")
    var done: Bool

    init() {}

    init(taskID: String, done: Bool) {
        self.taskID = taskID
        self.done = done
    }

    func perform() async throws -> some IntentResult {
        if let service = SupabaseService.fromStore() {
            try await service.setDone(taskID: taskID, done: done)

            // Optimistically update the shared snapshot so the next timeline
            // render is correct even before a fresh fetch lands.
            var snapshot = AppGroupStore.loadSnapshot()
            if done {
                snapshot.removeAll { $0.id == taskID }
            } else if let idx = snapshot.firstIndex(where: { $0.id == taskID }) {
                snapshot[idx].status = "todo"
            }
            AppGroupStore.saveSnapshot(snapshot)
        }
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
