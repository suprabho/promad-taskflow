import SwiftUI

struct ContentView: View {
    @StateObject private var model = WebViewModel()
    @State private var showURLSheet = false
    @State private var urlField = ""

    var body: some View {
        WebView(model: model)
            .overlay(alignment: .top) {
                if model.isLoading {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .tint(.accentColor)
                        .frame(maxWidth: .infinity)
                }
            }
            .overlay {
                if let error = model.loadError {
                    errorView(error)
                }
            }
            .toolbar { toolbarContent }
            .navigationTitle(model.title)
            .sheet(isPresented: $showURLSheet) { urlSheet }
            // Wire menu-bar commands (defined in TaskflowApp) to the model.
            .onReceive(NotificationCenter.default.publisher(for: .taskflowReload)) { _ in model.reload() }
            .onReceive(NotificationCenter.default.publisher(for: .taskflowGoHome)) { _ in model.loadHome() }
            .onReceive(NotificationCenter.default.publisher(for: .taskflowGoBack)) { _ in model.goBack() }
            .onReceive(NotificationCenter.default.publisher(for: .taskflowGoForward)) { _ in model.goForward() }
            .onReceive(NotificationCenter.default.publisher(for: .taskflowSetURL)) { _ in
                urlField = model.home.absoluteString
                showURLSheet = true
            }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigation) {
            Button { model.goBack() } label: { Image(systemName: "chevron.left") }
                .disabled(!model.canGoBack)
                .help("Back")
            Button { model.goForward() } label: { Image(systemName: "chevron.right") }
                .disabled(!model.canGoForward)
                .help("Forward")
        }
        ToolbarItemGroup(placement: .primaryAction) {
            Button { model.reload() } label: {
                Image(systemName: model.isLoading ? "xmark" : "arrow.clockwise")
            }
            .help(model.isLoading ? "Stop" : "Reload")
        }
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("Couldn’t load Taskflow")
                .font(.headline)
            Text(error)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)
            Text(model.home.absoluteString)
                .font(.caption.monospaced())
                .foregroundStyle(.tertiary)
            HStack {
                Button("Set Server URL…") {
                    urlField = model.home.absoluteString
                    showURLSheet = true
                }
                Button("Try Again") { model.reload() }
                    .keyboardShortcut(.defaultAction)
            }
            .padding(.top, 4)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }

    private var urlSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Server URL")
                .font(.headline)
            Text("Where the app loads Taskflow from. Restart after changing if a page is mid-load.")
                .font(.caption)
                .foregroundStyle(.secondary)
            TextField("https://taskflow.example.com", text: $urlField)
                .textFieldStyle(.roundedBorder)
                .frame(width: 380)
                .onSubmit(saveURL)
            HStack {
                Spacer()
                Button("Cancel") { showURLSheet = false }
                    .keyboardShortcut(.cancelAction)
                Button("Save & Load") { saveURL() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
    }

    private func saveURL() {
        AppConfig.saveUserURL(urlField)
        showURLSheet = false
        // model.home is computed from AppConfig, so it already reflects the
        // saved override — just (re)load it.
        model.loadHome()
    }
}
