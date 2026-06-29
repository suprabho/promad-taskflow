import SwiftUI
import AppKit

/// Content of the menu bar popover: a "Today & Overdue" checklist grouped by
/// project, plus actions. Swaps to an inline connect form when needed.
struct MenuBarView: View {
    @StateObject private var store = DayStore()
    @Environment(\.openWindow) private var openWindow
    @State private var showConnect = false

    var body: some View {
        VStack(spacing: 0) {
            if showConnect || !store.isConfigured {
                ConnectSupabaseForm(
                    onDone: { showConnect = false; Task { await store.refresh() } },
                    onCancel: store.isConfigured ? { showConnect = false } : nil
                )
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
                Text("Today & Overdue").font(.headline)
                Text(store.openCount == 0 ? "All clear" : "\(store.openCount) open")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
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
                        ProjectSection(group: group) { task in
                            Task { await store.toggle(task) }
                        }
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
            Text("Nothing due today").font(.callout).fontWeight(.medium)
            Text("You’re all caught up.").font(.caption).foregroundStyle(.secondary)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(group.name)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(.secondary)
            ForEach(group.tasks) { task in
                TaskRow(task: task) { onToggle(task) }
            }
        }
    }
}

/// A single task: checkbox + name + an overdue/today hint.
private struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

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

            if task.isOverdue() {
                Text("Overdue")
                    .font(.caption2).fontWeight(.medium)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.red.opacity(0.12), in: Capsule())
            } else if task.isDueToday() {
                Text("Today")
                    .font(.caption2).fontWeight(.medium)
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.orange.opacity(0.12), in: Capsule())
            }
        }
    }
}
