import Foundation

/// All configuration constants. Implementations must use these named constants, not magic numbers.
/// Reference: specs/behavior/EDGE_CASES.md — Configuration Constants
enum Constants {
    // MARK: - Auto-Save
    /// Debounce interval for auto-save timer
    static let DEBOUNCE_INTERVAL: TimeInterval = 0.3 // 300ms
    /// Delay before retrying a failed save
    static let SAVE_RETRY_DELAY: TimeInterval = 1.0 // 1000ms
    /// Maximum number of save retry attempts
    static let SAVE_MAX_RETRIES = 1

    // MARK: - Validation Limits
    /// Maximum length for note titles (characters)
    static let TITLE_MAX_LENGTH = 500
    /// Maximum length for folder names (characters)
    static let FOLDER_NAME_MAX_LENGTH = 100
    /// Maximum length for tag names (characters)
    static let TAG_NAME_MAX_LENGTH = 50
    /// Maximum tags allowed on a single note
    static let TAG_MAX_PER_NOTE = 20
    /// Maximum length for search queries (characters)
    static let SEARCH_QUERY_MAX_LENGTH = 500
    /// Maximum length for exported filenames before extension (characters)
    static let FILENAME_MAX_LENGTH = 200

    // MARK: - Window Dimensions
    /// Minimum window width (points)
    static let WINDOW_MIN_WIDTH: CGFloat = 600
    /// Minimum window height (points)
    static let WINDOW_MIN_HEIGHT: CGFloat = 400
    /// Default window width (points)
    static let WINDOW_DEFAULT_WIDTH: CGFloat = 1000
    /// Default window height (points)
    static let WINDOW_DEFAULT_HEIGHT: CGFloat = 650
    /// Default sidebar column width (points)
    static let SIDEBAR_DEFAULT_WIDTH: CGFloat = 200
    /// Default note list column width (points)
    static let NOTELIST_DEFAULT_WIDTH: CGFloat = 250

    // MARK: - Default Values
    /// Default title for newly created notes
    static let DEFAULT_NOTE_TITLE = "Untitled Note"
    /// Default name for newly created folders
    static let DEFAULT_FOLDER_NAME = "New Folder"
}
