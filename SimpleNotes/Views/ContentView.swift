import SwiftUI
import SwiftData

/// Main view containing the three-column NavigationSplitView layout.
/// Reference: specs/UI_DESIGN.md — Layout
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: NoteEditorViewModel?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        Group {
            if let viewModel {
                NavigationSplitView(columnVisibility: $columnVisibility) {
                    SidebarView(viewModel: viewModel)
                } content: {
                    NoteListView(viewModel: viewModel)
                } detail: {
                    NoteEditorView(viewModel: viewModel)
                }
                .frame(
                    minWidth: Constants.WINDOW_MIN_WIDTH,
                    minHeight: Constants.WINDOW_MIN_HEIGHT
                )
                .navigationSplitViewStyle(.balanced)
                // Provide ViewModel to menu commands via FocusedValues
                .focusedSceneValue(\.noteEditorViewModel, viewModel)
                // Flush pending saves on app termination
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: NSApplication.willTerminateNotification
                    )
                ) { _ in
                    viewModel.flushPendingSaves()
                }
                // Error alert (non-blocking)
                .alert(
                    String(localized: "Error"),
                    isPresented: Binding(
                        get: { viewModel.showError },
                        set: { viewModel.showError = $0 }
                    )
                ) {
                    Button(String(localized: "OK"), role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
            } else {
                ProgressView()
                    .frame(
                        minWidth: Constants.WINDOW_MIN_WIDTH,
                        minHeight: Constants.WINDOW_MIN_HEIGHT
                    )
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = NoteEditorViewModel(modelContext: modelContext)
            }
        }
    }
}

// MARK: - FocusedValues for Menu Commands

/// Provides the NoteEditorViewModel to the app-level menu commands.
struct FocusedNoteEditorViewModelKey: FocusedValueKey {
    typealias Value = NoteEditorViewModel
}

extension FocusedValues {
    var noteEditorViewModel: NoteEditorViewModel? {
        get { self[FocusedNoteEditorViewModelKey.self] }
        set { self[FocusedNoteEditorViewModelKey.self] = newValue }
    }
}
