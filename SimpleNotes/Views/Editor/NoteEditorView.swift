import SwiftUI

/// Note editor column with title field, body editor, and status bar.
/// Auto-saves on edit with 300ms debounce.
/// Reference: specs/UI_DESIGN.md — Editor (Column 3)
///            specs/behavior/STATE_MACHINE.md — ST-6: Auto-Save & Debounce
struct NoteEditorView: View {
    var viewModel: NoteEditorViewModel

    var body: some View {
        Group {
            if let note = viewModel.selectedNote {
                EditorContentView(note: note, viewModel: viewModel)
            } else {
                emptyState
            }
        }
    }

    // MARK: - Empty State

    /// Reference: specs/behavior/STATE_MACHINE.md — Empty State Rules
    /// Reference: specs/accessibility/LOCALIZATION.md — empty.selectNote
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(String(localized: "Select a note or press ⌘N to create one."))
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Editor Content

/// The actual editing UI for a selected note.
/// Separated into its own view so @Bindable works on the Note @Model.
private struct EditorContentView: View {
    @Bindable var note: Note
    var viewModel: NoteEditorViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Title field — large, borderless
            // Reference: specs/accessibility/LOCALIZATION.md — editor.titlePlaceholder
            TextField(
                String(localized: "Note Title"),
                text: titleBinding,
                axis: .vertical
            )
            .font(.title)
            .textFieldStyle(.plain)
            .lineLimit(1)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            // Reference: specs/accessibility/ACCESSIBILITY.md — Editor title field
            .accessibilityLabel(String(localized: "Note title"))
            .accessibilityHint(String(localized: "Edit the note title"))

            Divider()
                .padding(.horizontal, 16)

            // Body editor — monospaced, scrollable
            // Reference: specs/accessibility/ACCESSIBILITY.md — Editor body field
            TextEditor(text: bodyBinding)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .accessibilityLabel(String(localized: "Note body"))
                .accessibilityHint(String(localized: "Edit the note content"))

            Divider()

            // Status bar — word count, character count
            statusBar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Status Bar

    /// Bottom toolbar showing word and character count.
    /// Reference: specs/UI_DESIGN.md — Editor bottom toolbar
    /// Reference: specs/accessibility/LOCALIZATION.md — editor.wordCount, editor.charCount
    private var statusBar: some View {
        HStack {
            Spacer()

            Text(String(localized: "Words: \(viewModel.wordCount)"))
                .font(.caption)
                .foregroundStyle(.secondary)
                // Reference: specs/accessibility/ACCESSIBILITY.md — Word count
                .accessibilityLabel(String(localized: "\(viewModel.wordCount) words"))

            Text(String(localized: "Chars: \(viewModel.characterCount)"))
                .font(.caption)
                .foregroundStyle(.secondary)
                // Reference: specs/accessibility/ACCESSIBILITY.md — Character count
                .accessibilityLabel(String(localized: "\(viewModel.characterCount) characters"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }

    // MARK: - Bindings with Sanitization

    /// Title binding with sanitization: strips newlines/null bytes, truncates to 500 chars.
    /// Reference: specs/behavior/CONTRACTS.md — NoteService.update
    ///            specs/behavior/EDGE_CASES.md — Note Title Validation
    private var titleBinding: Binding<String> {
        Binding(
            get: { note.title },
            set: { newValue in
                var sanitized = newValue
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: "\r", with: "")
                    .replacingOccurrences(of: "\0", with: "")

                if sanitized.count > Constants.TITLE_MAX_LENGTH {
                    sanitized = String(sanitized.prefix(Constants.TITLE_MAX_LENGTH))
                }

                note.title = sanitized
                note.modifiedAt = .now
                viewModel.noteContentChanged()
            }
        )
    }

    /// Body binding with null byte sanitization.
    /// Reference: specs/behavior/EDGE_CASES.md — Note Body Validation
    private var bodyBinding: Binding<String> {
        Binding(
            get: { note.body },
            set: { newValue in
                note.body = newValue.replacingOccurrences(of: "\0", with: "")
                note.modifiedAt = .now
                viewModel.noteContentChanged()
            }
        )
    }
}
