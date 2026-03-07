import SwiftUI

/// Note list column showing all notes sorted by modification date.
/// Supports single selection, create (⌘N), and delete with confirmation.
/// Reference: specs/UI_DESIGN.md — Note List (Column 2)
///            specs/behavior/STATE_MACHINE.md — ST-1, ST-2
struct NoteListView: View {
    @Bindable var viewModel: NoteEditorViewModel

    var body: some View {
        Group {
            if viewModel.notes.isEmpty {
                emptyState
            } else {
                noteList
            }
        }
        .frame(minWidth: Constants.NOTELIST_DEFAULT_WIDTH)
        .navigationTitle(String(localized: "Notes"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.createNote()
                } label: {
                    Label(
                        String(localized: "New Note"),
                        systemImage: "square.and.pencil"
                    )
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
        // Delete confirmation dialog
        // Reference: specs/behavior/STATE_MACHINE.md — Confirmation Dialogs
        // Reference: specs/accessibility/LOCALIZATION.md — dialog.deleteNote.*
        .alert(
            String(localized: "Delete Note?"),
            isPresented: $viewModel.showDeleteConfirmation
        ) {
            Button(String(localized: "Cancel"), role: .cancel) {}
            Button(String(localized: "Delete"), role: .destructive) {
                viewModel.confirmDeleteNote()
            }
        } message: {
            if let title = viewModel.selectedNote?.title, !title.isEmpty {
                Text("Are you sure you want to delete \"\(title)\"? This cannot be undone.")
            } else {
                Text(String(localized: "Are you sure you want to delete this note? This cannot be undone."))
            }
        }
    }

    // MARK: - Note List

    private var noteList: some View {
        List(selection: Binding(
            get: { viewModel.selectedNote },
            set: { viewModel.selectNote($0) }
        )) {
            ForEach(viewModel.notes) { note in
                NoteRow(note: note)
                    .tag(note)
            }
        }
        .listStyle(.inset)
    }

    // MARK: - Empty State

    /// Reference: specs/behavior/STATE_MACHINE.md — Empty State Rules
    /// Reference: specs/accessibility/LOCALIZATION.md — empty.noNotes, empty.noNotesHint
    /// Reference: specs/accessibility/ACCESSIBILITY.md — Empty state label
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(String(localized: "No Notes Yet"))
                .font(.title2)
                .fontWeight(.medium)

            Text(String(localized: "Press ⌘N to create your first note."))
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "No notes. Press Command N to create your first note."))
    }
}
