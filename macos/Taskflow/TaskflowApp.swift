import SwiftUI

extension Notification.Name {
    static let taskflowReload = Notification.Name("taskflowReload")
    static let taskflowGoHome = Notification.Name("taskflowGoHome")
    static let taskflowGoBack = Notification.Name("taskflowGoBack")
    static let taskflowGoForward = Notification.Name("taskflowGoForward")
    static let taskflowSetURL = Notification.Name("taskflowSetURL")
}

@main
struct TaskflowApp: App {
    var body: some Scene {
        // A single main window (not WindowGroup) so "Open Taskflow" re-focuses
        // the existing window instead of spawning duplicates.
        Window("Taskflow", id: "main") {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowToolbarStyle(.unified)
        .commands {
            // Replace the default "New Window" noise with navigation commands.
            CommandGroup(after: .sidebar) {
                Button("Reload") { post(.taskflowReload) }
                    .keyboardShortcut("r", modifiers: .command)
                Button("Home") { post(.taskflowGoHome) }
                    .keyboardShortcut("h", modifiers: [.command, .shift])
                Divider()
                Button("Back") { post(.taskflowGoBack) }
                    .keyboardShortcut("[", modifiers: .command)
                Button("Forward") { post(.taskflowGoForward) }
                    .keyboardShortcut("]", modifiers: .command)
            }
            CommandGroup(after: .appSettings) {
                Button("Set Server URL…") { post(.taskflowSetURL) }
                    .keyboardShortcut("l", modifiers: .command)
            }
        }

        // Status-bar item: click to see the day's checklist popover.
        MenuBarExtra("Taskflow", systemImage: "checklist") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
    }

    private func post(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
}
