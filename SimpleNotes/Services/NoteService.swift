import SwiftData
import Foundation
import os.log

private let logger = Logger(subsystem: "com.simplenotes.app", category: "NoteService")

/// Stateless service for note CRUD operations. All methods accept a ModelContext parameter.
/// Reference: specs/behavior/CONTRACTS.md — NoteService
struct NoteService {

    // MARK: - Create

    /// Creates a new note with default values and inserts it into the context.
    /// - Parameters:
    ///   - folder: Optional folder to assign the note to. Pass nil for unfiled.
    ///   - context: The ModelContext to insert into.
    /// - Returns: The newly created Note.
    /// - Throws: SimpleNotesError.saveFailed if persistence fails.
    @discardableResult
    static func create(in folder: Folder? = nil, context: ModelContext) throws -> Note {
        let note = Note(folder: folder)
        context.insert(note)
        do {
            try context.save()
        } catch {
            throw SimpleNotesError.saveFailed(underlying: error)
        }
        return note
    }

    // MARK: - Update

    /// Updates a note's title and/or body. Sets modifiedAt to now.
    /// - Parameters:
    ///   - note: The note to update.
    ///   - title: New title (nil = no change). Stripped of newlines/null bytes, truncated to 500 chars.
    ///   - body: New body (nil = no change). Null bytes stripped.
    /// - Throws: SimpleNotesError.saveFailed if persistence fails.
    static func update(_ note: Note, title: String? = nil, body: String? = nil) {
        guard title != nil || body != nil else { return } // No-op

        if let title {
            var sanitized = title
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "\r", with: "")
                .replacingOccurrences(of: "\0", with: "")
            if sanitized.count > Constants.TITLE_MAX_LENGTH {
                sanitized = String(sanitized.prefix(Constants.TITLE_MAX_LENGTH))
                logger.debug("Title truncated to \(Constants.TITLE_MAX_LENGTH) characters")
            }
            note.title = sanitized
        }

        if let body {
            note.body = body.replacingOccurrences(of: "\0", with: "")
        }

        note.modifiedAt = .now
    }

    // MARK: - Delete

    /// Deletes a note from the context. Removes tag associations.
    /// - Parameters:
    ///   - note: The note to delete.
    ///   - context: The ModelContext.
    /// - Throws: SimpleNotesError.saveFailed if persistence fails.
    static func delete(_ note: Note, context: ModelContext) throws {
        context.delete(note)
        do {
            try context.save()
        } catch {
            throw SimpleNotesError.saveFailed(underlying: error)
        }
    }

    // MARK: - Fetch

    /// Fetches notes, optionally filtered by folder, sorted per spec.
    /// Sort order: isPinned desc → modifiedAt desc → createdAt desc → id asc (stable).
    /// - Parameters:
    ///   - folder: If non-nil, return only notes in this folder. If nil, return all notes.
    ///   - context: The ModelContext.
    /// - Returns: Sorted array of notes.
    static func fetchNotes(in folder: Folder? = nil, context: ModelContext) -> [Note] {
        let descriptor = FetchDescriptor<Note>()

        do {
            var notes = try context.fetch(descriptor)

            // Filter by folder if specified
            if let folder {
                notes = notes.filter { $0.folder?.id == folder.id }
            }

            // Sort with full tiebreaker chain per specs/behavior/EDGE_CASES.md
            notes.sort { lhs, rhs in
                // 1. isPinned — pinned first
                if lhs.isPinned != rhs.isPinned {
                    return lhs.isPinned && !rhs.isPinned
                }
                // 2. modifiedAt — newest first
                if lhs.modifiedAt != rhs.modifiedAt {
                    return lhs.modifiedAt > rhs.modifiedAt
                }
                // 3. createdAt — newest first (tiebreaker)
                if lhs.createdAt != rhs.createdAt {
                    return lhs.createdAt > rhs.createdAt
                }
                // 4. id ascending — final stable tiebreaker
                return lhs.id.uuidString < rhs.id.uuidString
            }

            return notes
        } catch {
            logger.error("Failed to fetch notes: \(error.localizedDescription)")
            return []
        }
    }
}
