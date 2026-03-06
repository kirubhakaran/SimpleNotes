# API Contracts

Formal method signatures, error types, and return contracts for all services and ViewModels.

---

## Error Types

```swift
enum SimpleNotesError: LocalizedError {
    // Note errors
    case noteNotFound(UUID)
    case noteTitleTooLong(count: Int, max: Int)

    // Folder errors
    case folderNotFound(UUID)
    case folderNameTooLong(count: Int, max: Int)
    case folderNameEmpty

    // Tag errors
    case tagNotFound(UUID)
    case tagNameTooLong(count: Int, max: Int)
    case tagLimitExceeded(noteId: UUID, max: Int)

    // Import/Export errors
    case unsupportedFileFormat(String)
    case fileNotFound(URL)
    case fileReadFailed(URL, underlying: Error)
    case fileWriteFailed(URL, underlying: Error)
    case fileEncodingError(URL)
    case exportDirectoryNotWritable(URL)

    // Persistence errors
    case saveFailed(underlying: Error)
    case databaseCorrupted
}
```

---

## NoteService

### create

```swift
/// Creates a new note with default values and inserts it into the context.
/// - Parameters:
///   - folder: Optional folder to assign the note to. Pass nil for unfiled.
///   - context: The ModelContext to insert into.
/// - Returns: The newly created Note.
/// - Throws: SimpleNotesError.saveFailed if persistence fails.
func create(in folder: Folder? = nil, context: ModelContext) throws -> Note
```

| Behavior | Detail |
|----------|--------|
| Title default | `"Untitled Note"` |
| Body default | `""` (empty string) |
| isPinned default | `false` |
| Timestamps | `createdAt` and `modifiedAt` set to `Date.now` |
| Folder | Set to parameter value (nil if not provided) |
| Tags | Empty array |

### update

```swift
/// Updates a note's title and/or body. Sets modifiedAt to now.
/// - Parameters:
///   - note: The note to update.
///   - title: New title (nil = no change). Truncated to 500 chars if longer.
///   - body: New body (nil = no change).
/// - Throws: SimpleNotesError.saveFailed if persistence fails.
func update(_ note: Note, title: String? = nil, body: String? = nil) throws
```

| Behavior | Detail |
|----------|--------|
| Title truncation | If title > 500 chars, silently truncate to 500 (no error) |
| Empty title | Allowed (empty string is valid) |
| modifiedAt | Always updated to `Date.now` on any change |
| No-op | If both title and body are nil, no update occurs |

### delete

```swift
/// Deletes a note from the context. Removes tag associations.
/// - Parameters:
///   - note: The note to delete.
///   - context: The ModelContext.
/// - Throws: SimpleNotesError.saveFailed if persistence fails.
func delete(_ note: Note, context: ModelContext) throws
```

| Behavior | Detail |
|----------|--------|
| Tag cleanup | Tag associations removed; tags themselves preserved |
| Folder cleanup | Note removed from folder's notes array |
| Pending debounce | If a debounce save is pending for this note, cancel it |

### duplicate

```swift
/// Creates a copy of the given note with "(Copy)" appended to title.
/// - Parameters:
///   - note: The source note.
///   - context: The ModelContext.
/// - Returns: The duplicated Note.
/// - Throws: SimpleNotesError.saveFailed if persistence fails.
func duplicate(_ note: Note, context: ModelContext) throws -> Note
```

| Behavior | Detail |
|----------|--------|
| Title | `"<original title> (Copy)"` |
| Title if duplicate exists | `"<original title> (Copy 2)"`, `"(Copy 3)"`, etc. |
| Body | Exact copy of original |
| Folder | Same folder as original |
| Tags | Same tags as original (shared references) |
| isPinned | Always `false` (never copy pin state) |
| Timestamps | Both set to `Date.now` (not copied from original) |
| ID | New UUID |

### togglePin

```swift
/// Toggles the isPinned state of a note.
/// - Parameter note: The note to pin/unpin.
/// - Throws: SimpleNotesError.saveFailed if persistence fails.
func togglePin(_ note: Note) throws
```

| Behavior | Detail |
|----------|--------|
| false → true | Note becomes pinned |
| true → false | Note becomes unpinned |
| modifiedAt | NOT updated (pin is metadata, not content edit) |

### fetchNotes

```swift
/// Fetches notes, optionally filtered by folder, sorted by pinned then modifiedAt.
/// - Parameters:
///   - folder: If non-nil, return only notes in this folder. If nil, return all notes.
///   - context: The ModelContext.
/// - Returns: Sorted array of notes.
func fetchNotes(in folder: Folder? = nil, context: ModelContext) -> [Note]
```

| Sort Order | Detail |
|------------|--------|
| Primary | `isPinned` descending (pinned first) |
| Secondary | `modifiedAt` descending (newest first) |
| Tiebreaker | `createdAt` descending (newest first) |
| Final tiebreaker | `id` string ascending (stable sort) |

### moveNote

```swift
/// Moves a note to a different folder (or to unfiled if nil).
/// - Parameters:
///   - note: The note to move.
///   - folder: Destination folder (nil = unfiled).
func moveNote(_ note: Note, to folder: Folder?) throws
```

| Behavior | Detail |
|----------|--------|
| Old folder | Note removed from old folder's `notes` array |
| New folder | Note added to new folder's `notes` array |
| modifiedAt | NOT updated (moving is organizational, not content edit) |

---

## FolderService

### create

```swift
/// Creates a new folder.
/// - Parameters:
///   - name: Folder name. Empty/whitespace-only defaults to "New Folder".
///           Truncated to 100 chars if longer.
///   - context: The ModelContext.
/// - Returns: The newly created Folder.
func create(name: String = "", context: ModelContext) throws -> Folder
```

| Behavior | Detail |
|----------|--------|
| Empty name | Defaults to `"New Folder"` |
| Whitespace-only name | Defaults to `"New Folder"` |
| Name truncation | Silently truncate to 100 chars |
| displayOrder | Set to max existing displayOrder + 1 (appended last) |
| Duplicate names | Allowed (no uniqueness constraint) |

### rename

```swift
/// Renames a folder.
/// - Parameters:
///   - folder: The folder to rename.
///   - name: New name. Whitespace-only is rejected (no change).
/// - Returns: true if renamed, false if rejected.
func rename(_ folder: Folder, to name: String) -> Bool
```

| Behavior | Detail |
|----------|--------|
| Valid name | Trimmed and applied |
| Empty string | Rejected, returns false |
| Whitespace-only | Rejected, returns false |
| Over 100 chars | Silently truncated to 100 |

### delete

```swift
/// Deletes a folder. Its notes become unfiled (folder = nil).
/// - Parameters:
///   - folder: The folder to delete.
///   - context: The ModelContext.
func delete(_ folder: Folder, context: ModelContext) throws
```

| Behavior | Detail |
|----------|--------|
| Notes | All notes in folder set to `folder = nil` (NOT deleted) |
| displayOrder | Remaining folders' displayOrder NOT recalculated |

### reorder

```swift
/// Moves a folder from one position to another, updating displayOrder values.
/// - Parameters:
///   - from: Source index.
///   - to: Destination index.
///   - context: The ModelContext.
func reorder(from: Int, to: Int, context: ModelContext) throws
```

| Behavior | Detail |
|----------|--------|
| All affected folders | displayOrder recalculated to maintain contiguous sequence |

---

## SearchService

### search

```swift
/// Searches notes by title and body content.
/// - Parameters:
///   - query: Search string. Empty/whitespace returns all notes.
///   - folder: Optional folder to scope search. nil = all notes.
///   - context: The ModelContext.
/// - Returns: Matching notes sorted by relevance then modifiedAt.
func search(_ query: String, in folder: Folder? = nil, context: ModelContext) -> [Note]
```

| Behavior | Detail |
|----------|--------|
| Case sensitivity | Case-insensitive |
| Empty query | Returns all notes (respecting folder scope) |
| Whitespace-only query | Treated as empty (trimmed) |
| Special characters | Treated as literal text, not regex. No crash. |
| Max query length | 500 characters (silently truncated) |
| Matching | Substring match on title and body |
| Markdown syntax | Searched as raw text (including `#`, `**`, etc.) |

| Sort Order | Detail |
|------------|--------|
| Primary | Title match before body-only match |
| Secondary | `isPinned` descending |
| Tertiary | `modifiedAt` descending |
| Tiebreaker | `createdAt` descending |

---

## ExportService

### exportAsMarkdown

```swift
/// Exports a note as a Markdown file.
/// - Parameter note: The note to export.
/// - Returns: Tuple of (fileData: Data, suggestedFilename: String).
func exportAsMarkdown(_ note: Note) -> (data: Data, filename: String)
```

| Behavior | Detail |
|----------|--------|
| Format | `# <title>\n\n<body>` |
| Encoding | UTF-8 |
| Filename | `<sanitized title>.md` |

### exportAsText

```swift
/// Exports a note as a plain text file.
/// - Parameter note: The note to export.
/// - Returns: Tuple of (fileData: Data, suggestedFilename: String).
func exportAsText(_ note: Note) -> (data: Data, filename: String)
```

| Behavior | Detail |
|----------|--------|
| Format | `<title>\n\n<body>` |
| Encoding | UTF-8 |
| Filename | `<sanitized title>.txt` |

### importFile

```swift
/// Imports a .md or .txt file as a new note.
/// - Parameters:
///   - url: File URL to import.
///   - folder: Optional folder to assign (nil = unfiled).
///   - context: The ModelContext.
/// - Returns: The created Note.
/// - Throws: SimpleNotesError.unsupportedFileFormat, .fileNotFound, .fileReadFailed, .fileEncodingError
func importFile(from url: URL, into folder: Folder? = nil, context: ModelContext) throws -> Note
```

| Behavior | Detail |
|----------|--------|
| Supported formats | `.md`, `.txt` only |
| Title extraction (.md) | First `# Heading` line; fallback to filename (without extension) |
| Title extraction (.txt) | Filename without extension |
| Body extraction (.md) | Everything after first `# Heading` line (trimmed) |
| Body extraction (.txt) | Full file content |
| Empty file | Note created with empty body |
| Encoding | UTF-8 required; throw `.fileEncodingError` if not decodable |
| File not found | Throw `.fileNotFound` |
| Unsupported type | Throw `.unsupportedFileFormat` |

### exportAll

```swift
/// Exports all notes as a zip archive preserving folder structure.
/// - Parameter context: The ModelContext.
/// - Returns: Tuple of (zipData: Data, suggestedFilename: String).
func exportAll(context: ModelContext) throws -> (data: Data, filename: String)
```

| Behavior | Detail |
|----------|--------|
| Folder structure | `<FolderName>/<NoteTitle>.md` for filed notes |
| Unfiled notes | Placed at root of zip |
| Duplicate filenames | Appended with ` (2)`, ` (3)`, etc. |
| Filename | `SimpleNotes-Export-<yyyy-MM-dd>.zip` |

### Filename Sanitization Rules

| Character | Replacement |
|-----------|-------------|
| `/` | `-` |
| `:` | `-` |
| `*` | `` (removed) |
| `?` | `` (removed) |
| `"` | `'` |
| `<` | `` (removed) |
| `>` | `` (removed) |
| `\|` | `-` |
| `\` | `-` |
| Leading/trailing spaces | Trimmed |
| Leading/trailing dots | Trimmed |
| Empty result after sanitization | `"Untitled"` |
| Max filename length | 200 characters (before extension) |

---

## SidebarViewModel

```swift
@Observable
class SidebarViewModel {
    var folders: [Folder]           // All folders sorted by displayOrder
    var selectedFolder: Folder?     // nil = "All Notes" mode
    var isRenamingFolder: Bool      // Whether rename UI is active
}
```

| Method | Return | Side Effects |
|--------|--------|-------------|
| `createFolder(name:)` | `Folder` | Adds to `folders`, sets as `selectedFolder` |
| `renameFolder(_:to:)` | `Bool` | Updates name if valid |
| `deleteFolder(_:)` | `Void` | Removes from `folders`, sets `selectedFolder = nil` |
| `moveFolder(from:to:)` | `Void` | Updates `displayOrder` on all affected folders |
| `selectFolder(_:)` | `Void` | Sets `selectedFolder`, clears active search |
| `selectAllNotes()` | `Void` | Sets `selectedFolder = nil`, clears active search |

---

## NoteEditorViewModel

```swift
@Observable
class NoteEditorViewModel {
    var notes: [Note]               // Notes in current view (filtered by folder/search)
    var selectedNote: Note?         // Currently selected note
    var searchQuery: String         // Active search text
    var isPreviewMode: Bool         // false = edit, true = preview
    var wordCount: Int              // Computed from selectedNote.body
    var characterCount: Int         // Computed from selectedNote.body
}
```

| Method | Return | Side Effects |
|--------|--------|-------------|
| `createNote()` | `Note` | Creates note in current folder, selects it, clears search |
| `deleteNote()` | `Void` | Deletes selected note, selects adjacent (see rules below) |
| `duplicateNote()` | `Note` | Duplicates selected note, selects the duplicate |
| `togglePin()` | `Void` | Toggles pin on selected note |
| `togglePreview()` | `Void` | Toggles `isPreviewMode` |
| `moveNote(_:to:)` | `Void` | Moves note to folder |
| `search(_:)` | `Void` | Updates `searchQuery`, filters `notes` |
| `clearSearch()` | `Void` | Clears `searchQuery`, restores full note list |
