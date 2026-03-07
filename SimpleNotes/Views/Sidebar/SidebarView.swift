import SwiftUI

/// Sidebar column showing "All Notes" and folders.
/// Phase 1: Only "All Notes" is shown. Folder management is Phase 2.
/// Reference: specs/UI_DESIGN.md — Sidebar (Column 1)
struct SidebarView: View {
    var viewModel: NoteEditorViewModel

    var body: some View {
        List {
            // "All Notes" — always present
            Label {
                Text(String(localized: "All Notes"))
            } icon: {
                Image(systemName: "note.text")
            }
            .tag(Optional<String>.none)

            // Folders section will be added in Phase 2
        }
        .listStyle(.sidebar)
        .navigationTitle(String(localized: "SimpleNotes"))
        .frame(minWidth: Constants.SIDEBAR_DEFAULT_WIDTH)
    }
}
