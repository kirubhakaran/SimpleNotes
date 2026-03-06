# Edge Cases, Validation & Configuration

Defines all boundary values, validation rules, sorting tiebreakers, concurrency model, and configuration constants.

---

## Configuration Constants

All hardcoded values in one place. Implementations must use named constants, not magic numbers.

| Constant | Value | Unit | Used In |
|----------|-------|------|---------|
| `DEBOUNCE_INTERVAL` | 300 | ms | Auto-save debounce timer |
| `SAVE_RETRY_DELAY` | 1000 | ms | Retry after save failure |
| `SAVE_MAX_RETRIES` | 1 | count | Max save retry attempts |
| `TITLE_MAX_LENGTH` | 500 | chars | Note title |
| `FOLDER_NAME_MAX_LENGTH` | 100 | chars | Folder name |
| `TAG_NAME_MAX_LENGTH` | 50 | chars | Tag name |
| `TAG_MAX_PER_NOTE` | 20 | count | Tags on a single note |
| `SEARCH_QUERY_MAX_LENGTH` | 500 | chars | Search input |
| `FILENAME_MAX_LENGTH` | 200 | chars | Exported filename (before extension) |
| `WINDOW_MIN_WIDTH` | 600 | pt | Minimum window width |
| `WINDOW_MIN_HEIGHT` | 400 | pt | Minimum window height |
| `WINDOW_DEFAULT_WIDTH` | 1000 | pt | Default window width |
| `WINDOW_DEFAULT_HEIGHT` | 650 | pt | Default window height |
| `SIDEBAR_DEFAULT_WIDTH` | 200 | pt | Sidebar column width |
| `NOTELIST_DEFAULT_WIDTH` | 250 | pt | Note list column width |

---

## Validation Rules

### Note Title

| Input | Behavior |
|-------|----------|
| Normal text (≤500 chars) | Accepted as-is |
| Text > 500 chars | Silently truncated to 500 chars |
| Empty string `""` | Allowed (valid note title) |
| Whitespace-only `"   "` | Allowed (valid note title) |
| Contains newlines | Newlines stripped (title is single-line) |
| Contains null bytes | Null bytes stripped |
| Unicode / emoji | Allowed |

### Note Body

| Input | Behavior |
|-------|----------|
| Any text | Accepted (no hard limit) |
| Empty string | Allowed |
| Very large (>1MB) | Allowed but may degrade performance; no enforcement |
| Contains null bytes | Null bytes stripped |
| Unicode / emoji / CJK | Allowed |
| Binary data | Rejected (not a valid string) |

### Folder Name

| Input | Behavior |
|-------|----------|
| Normal text (≤100 chars) | Accepted, trimmed of leading/trailing whitespace |
| Text > 100 chars | Silently truncated to 100 chars |
| Empty string `""` | Defaults to `"New Folder"` |
| Whitespace-only `"   "` | Rejected on rename (returns false); defaults to `"New Folder"` on create |
| Duplicate name | Allowed (no uniqueness constraint) |
| Case sensitivity | `"Work"` and `"work"` are distinct folders |
| Contains `/` or `:` | Allowed in folder name (only sanitized during export) |

### Tag Name

| Input | Behavior |
|-------|----------|
| Normal text (≤50 chars) | Accepted, trimmed |
| Text > 50 chars | Silently truncated to 50 chars |
| Empty string | Allowed (but should be discouraged in UI) |
| Duplicate name | Allowed (no uniqueness constraint) |
| Case sensitivity | `"Urgent"` and `"urgent"` are distinct tags |

### Tag Color

| Input | Behavior |
|-------|----------|
| `nil` | Allowed (no color) |
| Valid hex `"#FF0000"` | Accepted |
| Lowercase hex `"#ff0000"` | Accepted (case-insensitive) |
| 3-digit hex `"#F00"` | Accepted, expanded to 6-digit |
| Invalid format `"red"` | Stored as-is but rendered as default accent color |
| Empty string `""` | Treated as `nil` (no color) |

### Search Query

| Input | Behavior |
|-------|----------|
| Normal text | Case-insensitive substring search |
| Empty string | Returns all notes |
| Whitespace-only | Trimmed → treated as empty → returns all notes |
| Text > 500 chars | Silently truncated to 500 chars |
| Special chars `@#$%^&*()` | Treated as literal text, not regex |
| Regex patterns `.*+?[]` | Treated as literal text, not regex |
| Newlines / tabs | Stripped |
| SQL injection attempts | No effect (Swift Data uses parameterized queries) |

---

## Sorting Rules (with Tiebreakers)

### Note List Sorting

```
Sort order (all descending unless noted):

1. isPinned          — pinned (true) before unpinned (false)
2. modifiedAt        — newest first
3. createdAt         — newest first (tiebreaker for same modifiedAt)
4. id (as String)    — ascending, lexicographic (final stable tiebreaker)
```

### Pinned Notes Among Themselves

Pinned notes are sorted by the same rules (modifiedAt → createdAt → id), they just always appear above unpinned notes.

### Folder Sidebar Sorting

```
Sort order:

1. displayOrder      — ascending (0, 1, 2, ...)
2. createdAt         — ascending, oldest first (tiebreaker)
3. id (as String)    — ascending (final stable tiebreaker)
```

### Search Result Sorting

```
Sort order:

1. Match location    — title match before body-only match
2. isPinned          — pinned first
3. modifiedAt        — newest first
4. createdAt         — newest first (tiebreaker)
5. id (as String)    — ascending (final stable tiebreaker)
```

---

## Concurrency Model

### Threading Rules

| Operation | Thread | Rationale |
|-----------|--------|-----------|
| SwiftUI View rendering | Main | Required by SwiftUI |
| ViewModel property updates | Main | `@Observable` requires main thread |
| ModelContext read/write | Main | Swift Data ModelContext is not thread-safe |
| Debounce timer | Main | Timer fires on main RunLoop |
| Search execution | Main | Fast enough (<200ms target); avoids context threading issues |
| File import (reading bytes) | Background | File I/O can be slow |
| File export (writing bytes) | Background | File I/O can be slow |
| Zip creation | Background | Can be slow for many notes |

### Async Operations

```swift
// File import: background read, main context insert
func importFile(from url: URL, ...) async throws -> Note {
    let data = try await Task.detached { try Data(contentsOf: url) }.value  // background
    let note = // parse data
    await MainActor.run { context.insert(note) }  // main thread
    return note
}

// File export: main fetch, background write
func exportAsMarkdown(_ note: Note) async -> (data: Data, filename: String) {
    let content = await MainActor.run { formatNote(note) }  // main thread
    let data = await Task.detached { content.data(using: .utf8)! }.value  // background
    return (data, filename)
}
```

### Race Condition Prevention

| Scenario | Resolution |
|----------|------------|
| Rapid Cmd+N presses | Each creates a new note sequentially (main thread serializes) |
| Edit note during import | No conflict — different notes |
| Delete note while debounce pending | Cancel debounce timer first, then delete |
| Switch notes while debounce pending | Flush (immediate save) pending note, then switch |
| Drag note while auto-save is running | No conflict — drag changes folder, save changes content |
| Delete folder while note in folder selected | Folder delete completes first, note.folder becomes nil, view refreshes |

---

## Word and Character Count Rules

### Word Count

```swift
// Uses Foundation's word boundary detection
let wordCount = body.components(separatedBy: .whitespacesAndNewlines)
    .filter { !$0.isEmpty }
    .count
```

| Input | Word Count |
|-------|------------|
| `""` | 0 |
| `"hello"` | 1 |
| `"hello world"` | 2 |
| `"  hello   world  "` | 2 |
| `"hello\nworld"` | 2 |
| `"hello-world"` | 1 (hyphenated = one word) |
| `"hello—world"` (em dash) | 1 |
| `"## Heading"` | 2 (`##` counts as a word) |
| `"**bold**"` | 1 (`**bold**` is one token) |

### Character Count

```swift
let characterCount = body.count  // Swift String.count (grapheme clusters)
```

| Input | Char Count |
|-------|------------|
| `""` | 0 |
| `"hello"` | 5 |
| `"hello world"` | 11 (space counts) |
| `"emoji 😀"` | 7 (emoji = 1 grapheme) |
| `"café"` | 4 (é = 1 grapheme) |
| `"\n"` | 1 (newline counts) |

---

## Error Handling Behavior

### User-Facing Errors

| Error | UI Response |
|-------|-------------|
| Save failed | Non-blocking banner: "Unable to save. Retrying..." → retry once → if fail again: "Save failed. Your changes may not be persisted." |
| Import: file not found | Alert: "The file could not be found. It may have been moved or deleted." |
| Import: unsupported format | Alert: "Only .md and .txt files can be imported." |
| Import: encoding error | Alert: "The file could not be read. Please ensure it is a UTF-8 text file." |
| Export: write failed | Alert: "Unable to export. Please check disk space and permissions." |
| Database corrupted | Alert: "SimpleNotes data could not be loaded. The app will create a new database." → create fresh database |

### Silent Errors (Logged Only)

| Error | Handling |
|-------|----------|
| Title truncation | Silently truncate, log at debug level |
| Folder name truncation | Silently truncate, log at debug level |
| Tag limit exceeded | Silently reject 21st tag, log at info level |
| Invalid tag color format | Store as-is, render as default color |

---

## App Lifecycle

### First Launch

| State | Value |
|-------|-------|
| Notes | Empty (0 notes) |
| Folders | Empty (0 folders) |
| Selected folder | nil (All Notes) |
| Selected note | nil (empty state shown) |
| Preview mode | false (edit mode) |

### Subsequent Launches

| State | Value |
|-------|-------|
| Window position/size | Restored from previous session |
| Sidebar collapsed state | Restored from previous session |
| Column widths | Restored from previous session |
| Selected folder | nil (always resets to All Notes) |
| Selected note | First note in list (or nil if empty) |
| Search query | Empty (always resets) |
| Preview mode | false (always resets to edit mode) |

### App Termination

| Action | Behavior |
|--------|----------|
| Normal quit (Cmd+Q) | Flush all pending debounce saves, then quit |
| Force quit (Force Quit) | Pending debounce saves may be lost; last auto-saved state preserved |
| System shutdown | Same as normal quit (app receives termination notification) |
| Crash | Pending debounce saves lost; database has last successfully saved state |

---

## Multi-Selection

**Not supported in v1.** The app uses single-selection only:

- Only one note can be selected at a time
- Only one folder can be selected at a time
- Shift+click and Cmd+click in note list do nothing
- No batch operations (batch delete, batch move, batch export)
