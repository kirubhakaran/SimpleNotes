import SwiftUI
import SwiftData

/// SimpleNotes — a lightweight, native macOS notes app.
/// Reference: specs/ARCHITECTURE.md — App entry point
@main
struct SimpleNotesApp: App {
    /// FocusedValue binding to the active NoteEditorViewModel for menu commands.
    @FocusedValue(\.noteEditorViewModel) private var viewModel

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Note.self, Folder.self])
        .defaultSize(
            width: Constants.WINDOW_DEFAULT_WIDTH,
            height: Constants.WINDOW_DEFAULT_HEIGHT
        )
        .commands {
            // MARK: - File Menu Commands
            // Reference: specs/UI_DESIGN.md — Menu Bar

            // Replace default "New" with our "New Note"
            CommandGroup(replacing: .newItem) {
                Button(String(localized: "New Note")) {
                    viewModel?.createNote()
                }
                .keyboardShortcut("n", modifiers: .command)
                .disabled(viewModel == nil)

                // New Folder — Phase 2 (disabled placeholder)
                Button(String(localized: "New Folder")) {
                    // Phase 2: viewModel?.createFolder()
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])
                .disabled(true)

                Divider()
            }

            // MARK: - Edit Menu Additions
            CommandGroup(after: .pasteboard) {
                Divider()

                Button(String(localized: "Delete Note")) {
                    viewModel?.requestDeleteNote()
                }
                .keyboardShortcut(.delete, modifiers: .command)
                .disabled(viewModel?.selectedNote == nil)
            }
        }
    }
}
