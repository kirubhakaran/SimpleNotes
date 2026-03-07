import SwiftData
import Foundation

/// A single note with title, body, and metadata.
/// Reference: specs/DATA_MODEL.md — Note
@Model
final class Note {
    var id: UUID
    var title: String
    var body: String
    var isPinned: Bool
    var createdAt: Date
    var modifiedAt: Date

    /// Parent folder (nil = unfiled). Inverse of Folder.notes.
    var folder: Folder?

    // Tags relationship will be added in Phase 6
    // var tags: [Tag] = []

    init(
        title: String = Constants.DEFAULT_NOTE_TITLE,
        body: String = "",
        isPinned: Bool = false,
        folder: Folder? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.isPinned = isPinned
        self.createdAt = .now
        self.modifiedAt = .now
        self.folder = folder
    }
}
