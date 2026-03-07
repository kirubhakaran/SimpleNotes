import SwiftData
import Foundation

/// A folder that organizes notes. Deleting a folder unfiles its notes (does not delete them).
/// Reference: specs/DATA_MODEL.md — Folder
@Model
final class Folder {
    var id: UUID
    var name: String
    var displayOrder: Int
    var createdAt: Date

    /// Notes in this folder. Delete rule: nullify (notes become unfiled).
    @Relationship(deleteRule: .nullify, inverse: \Note.folder)
    var notes: [Note]

    init(
        name: String = Constants.DEFAULT_FOLDER_NAME,
        displayOrder: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.displayOrder = displayOrder
        self.createdAt = .now
        self.notes = []
    }
}
