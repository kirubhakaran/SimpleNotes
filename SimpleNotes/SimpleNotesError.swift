import Foundation

/// Typed error enum for all service operations.
/// Reference: specs/behavior/CONTRACTS.md — Error Types
enum SimpleNotesError: LocalizedError {
    // MARK: - Note Errors
    case noteNotFound(UUID)
    case noteTitleTooLong(count: Int, max: Int)

    // MARK: - Folder Errors
    case folderNotFound(UUID)
    case folderNameTooLong(count: Int, max: Int)
    case folderNameEmpty

    // MARK: - Tag Errors
    case tagNotFound(UUID)
    case tagNameTooLong(count: Int, max: Int)
    case tagLimitExceeded(noteId: UUID, max: Int)

    // MARK: - Import/Export Errors
    case unsupportedFileFormat(String)
    case fileNotFound(URL)
    case fileReadFailed(URL, underlying: Error)
    case fileWriteFailed(URL, underlying: Error)
    case fileEncodingError(URL)
    case exportDirectoryNotWritable(URL)

    // MARK: - Persistence Errors
    case saveFailed(underlying: Error)
    case databaseCorrupted

    var errorDescription: String? {
        switch self {
        case .noteNotFound:
            return String(localized: "The note could not be found.")
        case .noteTitleTooLong(let count, let max):
            return String(localized: "Note title is too long (\(count) characters, maximum \(max)).")
        case .folderNotFound:
            return String(localized: "The folder could not be found.")
        case .folderNameTooLong(let count, let max):
            return String(localized: "Folder name is too long (\(count) characters, maximum \(max)).")
        case .folderNameEmpty:
            return String(localized: "Folder name cannot be empty.")
        case .tagNotFound:
            return String(localized: "The tag could not be found.")
        case .tagNameTooLong(let count, let max):
            return String(localized: "Tag name is too long (\(count) characters, maximum \(max)).")
        case .tagLimitExceeded(_, let max):
            return String(localized: "A note can have at most \(max) tags.")
        case .unsupportedFileFormat:
            return String(localized: "Only .md and .txt files can be imported.")
        case .fileNotFound:
            return String(localized: "The file could not be found. It may have been moved or deleted.")
        case .fileReadFailed:
            return String(localized: "The file could not be read.")
        case .fileWriteFailed:
            return String(localized: "Unable to export. Please check disk space and permissions.")
        case .fileEncodingError:
            return String(localized: "The file could not be read. Please ensure it is a UTF-8 text file.")
        case .exportDirectoryNotWritable:
            return String(localized: "The export directory is not writable.")
        case .saveFailed:
            return String(localized: "Unable to save. Your changes may not be persisted.")
        case .databaseCorrupted:
            return String(localized: "SimpleNotes data could not be loaded. The app will create a new database.")
        }
    }
}
