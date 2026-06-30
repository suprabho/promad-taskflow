import SwiftUI

/// Inline form to connect the native surfaces to Supabase. The URL + anon key
/// are the same public values your web app ships (`NEXT_PUBLIC_SUPABASE_URL` /
/// `NEXT_PUBLIC_SUPABASE_ANON_KEY`). Stored in the App Group, shared with the
/// widget.
struct ConnectSupabaseForm: View {
    /// Called after a successful save.
    var onDone: () -> Void
    /// Provided only when there's existing config to cancel back to.
    var onCancel: (() -> Void)?

    @State private var url = AppGroupStore.supabaseURL ?? ""
    @State private var anonKey = AppGroupStore.supabaseAnonKey ?? ""
    @State private var workspace = AppGroupStore.workspaceID

    private var canSave: Bool {
        !url.trimmingCharacters(in: .whitespaces).isEmpty
            && !anonKey.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Connect to Supabase").font(.headline)
                Text("From your web app’s .env — both values are public.")
                    .font(.caption).foregroundStyle(.secondary)
            }

            field("Project URL", text: $url, prompt: "https://xxxx.supabase.co")
            field("Anon key", text: $anonKey, prompt: "eyJhbGciOi…", secure: true)
            field("Workspace ID", text: $workspace, prompt: "ws-1")

            HStack {
                if let onCancel {
                    Button("Cancel", action: onCancel)
                        .keyboardShortcut(.cancelAction)
                }
                Spacer()
                Button("Save") {
                    AppGroupStore.saveCredentials(url: url, anonKey: anonKey, workspace: workspace)
                    onDone()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)
            }
        }
        .padding(16)
        .frame(width: 340)
    }

    @ViewBuilder
    private func field(_ label: String, text: Binding<String>, prompt: String, secure: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Group {
                if secure {
                    SecureField(prompt, text: text)
                } else {
                    TextField(prompt, text: text)
                }
            }
            .textFieldStyle(.roundedBorder)
            .font(.callout)
        }
    }
}
