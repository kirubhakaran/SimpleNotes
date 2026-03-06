# Localization Specification

Defines the internationalization (i18n) strategy so the app is localization-ready from day one, even though v1 ships English-only.

---

## Strategy

| Decision | Choice |
|----------|--------|
| Default language | English (en) |
| v1 supported languages | English only |
| Localization framework | Swift String Catalogs (`.xcstrings`) |
| String externalization | All user-facing strings in `Localizable.xcstrings` |
| Date/number formatting | Foundation formatters (locale-aware) |
| Plural handling | String Catalog plural rules |
| Right-to-left (RTL) | SwiftUI auto-layout (no manual mirroring needed) |

---

## String Catalog

All user-facing strings must be defined as localization keys. No hardcoded user-facing text in code.

### App Chrome

| Key | English (en) | Context |
|-----|-------------|---------|
| `sidebar.allNotes` | `"All Notes"` | Sidebar button |
| `sidebar.newFolder` | `"New Folder"` | Default folder name / button label |
| `sidebar.folderSection` | `"Folders"` | Sidebar section header |

### Note Defaults

| Key | English (en) | Context |
|-----|-------------|---------|
| `note.untitledDefault` | `"Untitled Note"` | Default title for new notes |
| `note.copyTitle` | `"%@ (Copy)"` | Duplicate note title; `%@` = original title |
| `note.copyTitleNumbered` | `"%@ (Copy %lld)"` | Subsequent duplicates; `%@` = title, `%lld` = number |

### Editor

| Key | English (en) | Context |
|-----|-------------|---------|
| `editor.editMode` | `"Edit"` | Edit toggle button |
| `editor.previewMode` | `"Preview"` | Preview toggle button |
| `editor.wordCount` | `"Words: %lld"` | Status bar word count |
| `editor.charCount` | `"Chars: %lld"` | Status bar character count |
| `editor.titlePlaceholder` | `"Note Title"` | Title field placeholder |

### Search

| Key | English (en) | Context |
|-----|-------------|---------|
| `search.placeholder` | `"Search..."` | Search bar placeholder |
| `search.noResults` | `"No results for \"%@\""` | Empty search state; `%@` = query |
| `search.noResultsHint` | `"Try a different search term."` | Below no results message |

### Empty States

| Key | English (en) | Context |
|-----|-------------|---------|
| `empty.noNotes` | `"No Notes Yet"` | No notes exist |
| `empty.noNotesHint` | `"Press ⌘N to create your first note."` | Below no notes message |
| `empty.folderEmpty` | `"No Notes"` | Empty folder |
| `empty.folderEmptyHint` | `"Press ⌘N to create a note."` | Below empty folder message |
| `empty.selectNote` | `"Select a note or press ⌘N to create one."` | No note selected in editor |

### Dialogs

| Key | English (en) | Context |
|-----|-------------|---------|
| `dialog.deleteNote.title` | `"Delete Note?"` | Delete note confirmation |
| `dialog.deleteNote.message` | `"Are you sure you want to delete \"%@\"? This cannot be undone."` | `%@` = note title |
| `dialog.deleteFolder.title` | `"Delete Folder?"` | Delete folder confirmation |
| `dialog.deleteFolder.message` | `"Are you sure you want to delete \"%@\"? The %lld notes in this folder will not be deleted."` | `%@` = folder name, `%lld` = count |
| `dialog.deleteFolder.messageEmpty` | `"Are you sure you want to delete \"%@\"?"` | Empty folder |
| `dialog.cancel` | `"Cancel"` | Cancel button |
| `dialog.delete` | `"Delete"` | Destructive delete button |

### Context Menus

| Key | English (en) | Context |
|-----|-------------|---------|
| `menu.pin` | `"Pin"` | Pin note action |
| `menu.unpin` | `"Unpin"` | Unpin note action |
| `menu.duplicate` | `"Duplicate"` | Duplicate note action |
| `menu.moveToFolder` | `"Move to Folder"` | Move note submenu |
| `menu.delete` | `"Delete"` | Delete action |
| `menu.rename` | `"Rename"` | Rename folder action |

### Menu Bar

| Key | English (en) | Context |
|-----|-------------|---------|
| `menubar.file.newNote` | `"New Note"` | File > New Note |
| `menubar.file.newFolder` | `"New Folder"` | File > New Folder |
| `menubar.file.import` | `"Import..."` | File > Import |
| `menubar.file.exportNote` | `"Export Note..."` | File > Export Note |
| `menubar.file.exportAll` | `"Export All Notes..."` | File > Export All |
| `menubar.view.toggleSidebar` | `"Toggle Sidebar"` | View > Toggle Sidebar |
| `menubar.view.togglePreview` | `"Toggle Preview"` | View > Toggle Preview |
| `menubar.view.sortBy` | `"Sort By"` | View > Sort By |
| `menubar.view.sortDateModified` | `"Date Modified"` | Sort option |
| `menubar.view.sortDateCreated` | `"Date Created"` | Sort option |
| `menubar.view.sortTitle` | `"Title"` | Sort option |
| `menubar.format.bold` | `"Bold"` | Format > Bold |
| `menubar.format.italic` | `"Italic"` | Format > Italic |
| `menubar.format.heading1` | `"Heading 1"` | Format > Heading 1 |
| `menubar.format.heading2` | `"Heading 2"` | Format > Heading 2 |
| `menubar.format.heading3` | `"Heading 3"` | Format > Heading 3 |
| `menubar.format.codeBlock` | `"Code Block"` | Format > Code Block |
| `menubar.format.bulletList` | `"Bullet List"` | Format > Bullet List |
| `menubar.format.numberedList` | `"Numbered List"` | Format > Numbered List |

### Error Messages

| Key | English (en) | Context |
|-----|-------------|---------|
| `error.saveFailed` | `"Unable to save. Retrying..."` | Save failure banner |
| `error.saveFailedFinal` | `"Save failed. Your changes may not be persisted."` | After retry fails |
| `error.importNotFound` | `"The file could not be found. It may have been moved or deleted."` | Import file missing |
| `error.importUnsupported` | `"Only .md and .txt files can be imported."` | Wrong file type |
| `error.importEncoding` | `"The file could not be read. Please ensure it is a UTF-8 text file."` | Encoding error |
| `error.exportFailed` | `"Unable to export. Please check disk space and permissions."` | Export write error |
| `error.databaseCorrupted` | `"SimpleNotes data could not be loaded. The app will create a new database."` | DB corruption |

### Accessibility Labels

| Key | English (en) | Context |
|-----|-------------|---------|
| `a11y.noteRow` | `"%@, %@, %@"` | title, preview, date |
| `a11y.noteRowPinned` | `"Pinned, %@, %@, %@"` | pinned prefix |
| `a11y.folderRow` | `"%@, %lld notes"` | folder name, count |
| `a11y.searchBar` | `"Search notes"` | Search field label |
| `a11y.noteTitle` | `"Note title"` | Editor title field |
| `a11y.noteBody` | `"Note body"` | Editor body field |
| `a11y.wordCount` | `"%lld words"` | Status bar |
| `a11y.charCount` | `"%lld characters"` | Status bar |

---

## Date Formatting

All dates use Foundation formatters, **never** manual string formatting.

```swift
// Relative dates in note list (e.g., "Today", "Yesterday", "Mar 3")
let formatter = RelativeDateTimeFormatter()
formatter.dateTimeStyle = .named    // "today", "yesterday"
formatter.unitsStyle = .full

// Fallback for dates older than a week
let dateFormatter = DateFormatter()
dateFormatter.doesRelativeDateFormatting = true
dateFormatter.dateStyle = .medium   // Locale-aware: "Mar 3, 2026" (en), "3 mars 2026" (fr)
dateFormatter.timeStyle = .short    // "2:30 PM" (en), "14:30" (fr)
```

| Age | Display Format (en) | Example |
|-----|---------------------|---------|
| Today | `"Today {time}"` | `"Today 2:30 PM"` |
| Yesterday | `"Yesterday"` | `"Yesterday"` |
| This week | `"{weekday}"` | `"Monday"` |
| This year | `"{month} {day}"` | `"Mar 3"` |
| Older | `"{month} {day}, {year}"` | `"Dec 15, 2025"` |

---

## Number Formatting

```swift
// Word and character counts
let formatter = NumberFormatter()
formatter.numberStyle = .decimal    // Locale-aware: "1,234" (en), "1.234" (de)
```

---

## Export Filename Locale

Exported filenames always use the **note title** (sanitized), never localized metadata. The export format (`# Title`) is not localized — Markdown is language-neutral.

---

## Implementation Rules

1. **Never hardcode user-facing strings** — always use `String(localized:)` or `LocalizedStringKey`
2. **Never concatenate localized strings** — use format strings with `%@` / `%lld` placeholders
3. **Never format dates manually** — always use `DateFormatter` or `RelativeDateTimeFormatter`
4. **Never format numbers manually** — always use `NumberFormatter`
5. **Use String Catalogs** — one `Localizable.xcstrings` file at project root
6. **Mark all format arguments** — use `%@` for strings, `%lld` for integers
7. **Test with pseudolocalization** — Xcode scheme > Options > App Language > Pseudolanguage
