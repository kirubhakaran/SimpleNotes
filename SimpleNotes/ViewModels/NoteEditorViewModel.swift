import SwiftData
import SwiftUI
import os.log

private let logger = Logger(subsystem: "com.simplenotes.app", category: "NoteEditorViewModel")

/// Main ViewModel for the note editor and note list.
/// Manages note CRUD, selection, auto-save debounce, and state transitions.
/// Reference: specs/behavior/CONTRACTS.md — NoteEditorViewModel
///            specs/behavior/STATE_MACHINE.md — State Transition Rules
@Observable
class NoteEditorViewModel {

    // MARK: - Published State

    /// Notes in current view (sorted by pinned → modifiedAt → createdAt → id)
    var notes: [Note] = []

    /// Currently selected note (nil = empty editor state)
    var selectedNote: Note?

    /// Active search text (Phase 2 — empty for Phase 1)
    var searchQuery: String = ""

    /// Edit vs preview mode (Phase 3 — always false for Phase 1)
    var isPreviewMode: Bool = false

    /// Whether the delete confirmation dialog is presented
    var showDeleteConfirmation: Bool = false

    /// Error message to display to the user (non-blocking)
    var errorMessage: String?
    var showError: Bool = false

    // MARK: - Computed Properties

    /// Word count for the selected note's body.
    /// Reference: specs/behavior/EDGE_CASES.md — Word Count Rules
    var wordCount: Int {
        guard let body = selectedNote?.body, !body.isEmpty else { return 0 }
        return body.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }

    /// Character count for the selected note's body (grapheme clusters).
    /// Reference: specs/behavior/EDGE_CASES.md — Character Count Rules
    var characterCount: Int {
        selectedNote?.body.count ?? 0
    }

    // MARK: - Private State

    private var debounceTimer: Timer?
    private var modelContext: ModelContext

    // MARK: - Init

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadNotes()

        // ST-1: App launch — select first note in list
        selectedNote = notes.first
    }

    // MARK: - Data Loading

    /// Fetches all notes from the context and sorts them per spec.
    /// For Phase 1, always fetches all notes (no folder filtering).
    func loadNotes(in folder: Folder? = nil) {
        notes = NoteService.fetchNotes(in: folder, context: modelContext)
    }

    // MARK: - Note CRUD

    /// Creates a new note in the current folder.
    /// ST-1: selectedNote = new note, isPreviewMode = false, searchQuery = ""
    func createNote(in folder: Folder? = nil) {
        flushPendingSaves()

        do {
            let note = try NoteService.create(in: folder, context: modelContext)
            searchQuery = ""
            isPreviewMode = false
            loadNotes(in: folder)
            selectedNote = note
        } catch {
            logger.error("Failed to create note: \(error.localizedDescription)")
            showErrorMessage(String(localized: "Unable to create note."))
        }
    }

    /// Requests deletion of the selected note (shows confirmation dialog).
    /// Cmd+Backspace triggers this. No-op if no note is selected.
    func requestDeleteNote() {
        guard selectedNote != nil else { return }
        showDeleteConfirmation = true
    }

    /// Confirms and performs deletion of the selected note.
    /// Applies ST-2: Post-Delete Selection algorithm.
    func confirmDeleteNote(in folder: Folder? = nil) {
        guard let note = selectedNote else { return }

        // Cancel any pending debounce for this note
        cancelDebounce()

        // Capture index before deletion for ST-2
        let currentIndex = notes.firstIndex(where: { $0.id == note.id })
        let totalCount = notes.count

        do {
            try NoteService.delete(note, context: modelContext)
            loadNotes(in: folder)

            // ST-2: Post-Delete Selection
            applyPostDeleteSelection(
                deletedIndex: currentIndex ?? 0,
                previousCount: totalCount
            )
        } catch {
            logger.error("Failed to delete note: \(error.localizedDescription)")
            showErrorMessage(String(localized: "Unable to delete note."))
        }

        showDeleteConfirmation = false
    }

    /// Selects a note. Flushes pending saves before switching.
    /// ST-1: isPreviewMode unchanged on note switch.
    func selectNote(_ note: Note?) {
        guard note?.id != selectedNote?.id else { return }
        flushPendingSaves()
        selectedNote = note
    }

    // MARK: - Auto-Save / Debounce

    /// Called when note content changes (title or body edit).
    /// Restarts the debounce timer (300ms). Updates modifiedAt.
    /// Reference: specs/behavior/STATE_MACHINE.md — ST-6
    func noteContentChanged() {
        debounceTimer?.invalidate()

        debounceTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.DEBOUNCE_INTERVAL,
            repeats: false
        ) { [weak self] _ in
            self?.saveContext()
        }
    }

    /// Immediately saves all pending debounce changes.
    /// Call on: note switch, app termination, app background.
    /// Reference: specs/behavior/CONTRACTS.md — flushPendingSaves
    func flushPendingSaves() {
        debounceTimer?.invalidate()
        debounceTimer = nil
        saveContext()
    }

    // MARK: - Private Helpers

    /// Cancels the debounce timer without saving.
    /// Used before delete (we don't want to save a note we're about to delete).
    private func cancelDebounce() {
        debounceTimer?.invalidate()
        debounceTimer = nil
    }

    /// Persists all dirty objects in the ModelContext to disk.
    /// Retries once on failure per spec.
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            logger.error("Save failed: \(error.localizedDescription)")

            // Retry once after SAVE_RETRY_DELAY
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Constants.SAVE_RETRY_DELAY
            ) { [weak self] in
                do {
                    try self?.modelContext.save()
                } catch {
                    logger.error("Save retry failed: \(error.localizedDescription)")
                    self?.showErrorMessage(
                        String(localized: "Save failed. Your changes may not be persisted.")
                    )
                }
            }
        }
    }

    /// Applies the Post-Delete Selection algorithm (ST-2).
    /// Reference: specs/behavior/STATE_MACHINE.md — ST-2
    ///
    /// After deleting note at index I from list of N notes:
    /// - If N == 1 (only note): selectedNote = nil
    /// - If I < N - 1 (not last): selectedNote = note at same index I
    /// - If I == N - 1 (last item): selectedNote = note at I - 1
    private func applyPostDeleteSelection(deletedIndex: Int, previousCount: Int) {
        if previousCount <= 1 {
            // Was the only note
            selectedNote = nil
        } else if deletedIndex < previousCount - 1 {
            // Not the last item — select the note that moved into this index
            if deletedIndex < notes.count {
                selectedNote = notes[deletedIndex]
            } else {
                selectedNote = notes.last
            }
        } else {
            // Was the last item — select the new last item
            selectedNote = notes.last
        }
    }

    /// Shows a non-blocking error message.
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
