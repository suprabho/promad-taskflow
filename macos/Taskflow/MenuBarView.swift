import SwiftUI
import AppKit

/// Content of the menu bar popover: a "Today & Overdue" checklist grouped by
/// project, plus actions. Swaps to an inline connect form when needed.
struct MenuBarView: View {
    @StateObject private var store = DayStore()
    @Environment(\.openWindow) private var openWindow
    @State private var showConnect = false
    @State private var showAdd = false

    var body: some View {
        VStack(spacing: 0) {
            if showConnect || !store.isConfigured {
                ConnectSupabaseForm(
                    onDone: { showConnect = false; Task { await store.refresh() } },
                    onCancel: store.isConfigured ? { showConnect = false } : nil
                )
            } else if showAdd {
                AddTaskForm(store: store, onClose: { showAdd = false })
            } else {
                header
                Divider()
                content
                Divider()
                footer
            }
        }
        .frame(width: 340)
        .frame(maxHeight: 520)
        .task { await store.refresh() }
    }

    // MARK: Header

    private var header: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 1) {
                Text("Today & Upcoming").font(.headline)
                Text(store.openCount == 0 ? "Nothing scheduled" : "\(store.openCount) upcoming")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                Task { await store.loadFormData() }
                showAdd = true
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(.borderless)
            .help("Add task")

            if store.isLoading {
                ProgressView().controlSize(.small)
            } else {
                Button { Task { await store.refresh() } } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.borderless)
                .help("Refresh")
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
    }

    // MARK: List

    @ViewBuilder
    private var content: some View {
        if let error = store.errorMessage {
            errorState(error)
        } else if store.groups.isEmpty {
            emptyState
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(store.groups) { group in
                        ProjectSection(
                            group: group,
                            onToggle: { task in Task { await store.toggle(task) } },
                            onSnooze: { task in store.snooze(task) }
                        )
                    }
                }
                .padding(14)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 30)).foregroundStyle(.green)
            Text("Nothing coming up").font(.callout).fontWeight(.medium)
            Text("No tasks due today or later.").font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 36)
    }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 26)).foregroundStyle(.orange)
            Text("Couldn’t load tasks").font(.callout).fontWeight(.medium)
            Text(message).font(.caption).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).frame(maxWidth: 280)
            HStack {
                Button("Reconnect") { showConnect = true }
                Button("Retry") { Task { await store.refresh() } }
            }
        }
        .frame(maxWidth: .infinity).padding(.vertical, 24).padding(.horizontal, 14)
    }

    // MARK: Footer

    private var footer: some View {
        HStack {
            Button {
                NSApp.activate(ignoringOtherApps: true)
                openWindow(id: "main")
            } label: { Label("Open Taskflow", systemImage: "macwindow") }
                .buttonStyle(.borderless)

            Spacer()

            Menu {
                Button("Connect to Supabase…") { showConnect = true }
                if let updated = store.lastUpdated {
                    Text("Updated \(updated.formatted(date: .omitted, time: .shortened))")
                }
                Divider()
                Button("Quit Taskflow") { NSApp.terminate(nil) }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .menuStyle(.borderlessButton)
            .frame(width: 28)
        }
        .padding(.horizontal, 14).padding(.vertical, 8)
    }
}

/// One project's card: a header and its task rows.
private struct ProjectSection: View {
    let group: ProjectGroup
    let onToggle: (TaskItem) -> Void
    let onSnooze: (TaskItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(group.name)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(.secondary)
            ForEach(group.tasks) { task in
                TaskRow(task: task,
                        onToggle: { onToggle(task) },
                        onSnooze: { onSnooze(task) })
            }
        }
    }
}

/// A single task: checkbox + name + due hint + a snooze button (on hover).
private struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void
    let onSnooze: () -> Void
    @State private var hovering = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isDone ? .green : .secondary)
            }
            .buttonStyle(.borderless)

            Text(task.name)
                .font(.callout)
                .strikethrough(task.isDone)
                .foregroundStyle(task.isDone ? .secondary : .primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 4)

            dueBadge

            // Snooze: reveal on hover to keep the row clean.
            Button(action: onSnooze) {
                Image(systemName: "moon.zzz.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            .help("Snooze until tomorrow")
            .opacity(hovering ? 1 : 0)
        }
        .contentShape(Rectangle())
        .onHover { hovering = $0 }
    }

    @ViewBuilder
    private var dueBadge: some View {
        let color: Color = task.isDueToday() ? .orange : (task.isDueTomorrow() ? .blue : .secondary)
        Text(task.dueLabel)
            .font(.caption2).fontWeight(.medium)
            .foregroundStyle(color)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(color.opacity(0.12), in: Capsule())
    }
}

/// Inline form to create a new task in Supabase.
private struct AddTaskForm: View {
    @ObservedObject var store: DayStore
    var onClose: () -> Void

    @State private var name = ""
    @State private var status = "todo"
    @State private var priority = "medium"
    @State private var project = ""
    @State private var includeDueDate = true
    @State private var dueDate = Date()
    @State private var assignees: Set<String> = []
    @State private var submitting = false
    @State private var error: String?

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !submitting
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("New Task").font(.headline)
                Spacer()
                Button(action: onClose) { Image(systemName: "xmark") }
                    .buttonStyle(.borderless)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    field("Name") {
                        TextField("Task name", text: $name).textFieldStyle(.roundedBorder)
                    }
                    HStack(alignment: .top, spacing: 10) {
                        field("Status") {
                            Picker("", selection: $status) {
                                ForEach(TaskOptions.statuses, id: \.value) { Text($0.label).tag($0.value) }
                            }.labelsHidden()
                        }
                        field("Priority") {
                            Picker("", selection: $priority) {
                                ForEach(TaskOptions.priorities, id: \.value) { Text($0.label).tag($0.value) }
                            }.labelsHidden()
                        }
                    }
                    field("Project") {
                        HStack(spacing: 6) {
                            TextField("Project name", text: $project).textFieldStyle(.roundedBorder)
                            if !store.projects.isEmpty {
                                Menu {
                                    ForEach(store.projects, id: \.self) { p in
                                        Button(p) { project = p }
                                    }
                                } label: { Image(systemName: "chevron.down") }
                                    .menuStyle(.borderlessButton).frame(width: 22)
                            }
                        }
                    }
                    field("Due date") {
                        HStack(spacing: 8) {
                            Toggle("", isOn: $includeDueDate).labelsHidden().toggleStyle(.switch)
                            if includeDueDate {
                                DatePicker("", selection: $dueDate, displayedComponents: .date).labelsHidden()
                            } else {
                                Text("No due date").font(.callout).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                    field("Assignees") {
                        Menu {
                            ForEach(store.users) { u in
                                if assignees.contains(u.id) {
                                    Button { assignees.remove(u.id) } label: { Label(u.name, systemImage: "checkmark") }
                                } else {
                                    Button(u.name) { assignees.insert(u.id) }
                                }
                            }
                        } label: {
                            Text(assigneeLabel).lineLimit(1)
                        }
                        .menuStyle(.borderlessButton)
                    }

                    if let error {
                        Text(error).font(.caption).foregroundStyle(.red)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(14)
            }

            Divider()
            HStack {
                Button("Cancel", action: onClose).keyboardShortcut(.cancelAction)
                Spacer()
                Button(submitting ? "Adding…" : "Add Task") { submit() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(!canSave)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
        }
        .task { await store.loadFormData() }
    }

    private var assigneeLabel: String {
        if assignees.isEmpty { return "Unassigned" }
        return store.users.filter { assignees.contains($0.id) }.map(\.name).joined(separator: ", ")
    }

    @ViewBuilder
    private func field<Content: View>(_ label: String, @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            content()
        }
    }

    private func submit() {
        error = nil
        submitting = true
        let due = includeDueDate ? TaskflowDate.isoDate(dueDate) : nil
        let proj = project.trimmingCharacters(in: .whitespaces)
        Task {
            let ok = await store.createTask(
                name: name.trimmingCharacters(in: .whitespaces),
                status: status, priority: priority,
                project: proj.isEmpty ? nil : proj,
                dueDate: due, assignees: Array(assignees))
            submitting = false
            if ok { onClose() } else { error = store.errorMessage ?? "Couldn’t create the task." }
        }
    }
}
