# Test Cases: Services

Unit tests for `NoteService`, `SearchService`, and `ExportService`.

---

## TC-S1: NoteService

### TC-S1.1: Create Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.1                                               |
| **Requirement**| FR-1.1                                                |
| **Description**| Service creates a note and inserts it into context    |
| **Steps**      | 1. Call `NoteService.create(context:)`                |
|                | 2. Fetch all notes                                    |
| **Expected**   | Notes count increased by 1, new note has defaults     |
| **Priority**   | Must                                                  |

### TC-S1.2: Create Note in Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.2                                               |
| **Requirement**| FR-1.1, FR-2.1                                        |
| **Description**| Service creates a note assigned to a specific folder  |
| **Steps**      | 1. Call `NoteService.create(in: folder, context:)`    |
| **Expected**   | `newNote.folder == folder`                            |
| **Priority**   | Must                                                  |

### TC-S1.3: Delete Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.3                                               |
| **Requirement**| FR-1.3                                                |
| **Description**| Service deletes a note from the context               |
| **Steps**      | 1. Create a note                                      |
|                | 2. Call `NoteService.delete(note, context:)`          |
|                | 3. Fetch all notes                                    |
| **Expected**   | Note no longer exists in context                      |
| **Priority**   | Must                                                  |

### TC-S1.4: Delete Note - Removes Tag Associations

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.4                                               |
| **Requirement**| DATA_MODEL (cascade)                                  |
| **Description**| Deleting a note removes it from tag associations      |
| **Steps**      | 1. Create note with 2 tags                            |
|                | 2. Delete the note                                    |
|                | 3. Check both tags                                    |
| **Expected**   | Tags still exist, `tag.notes` no longer contains the deleted note |
| **Priority**   | Should                                                |

### TC-S1.5: Duplicate Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.5                                               |
| **Requirement**| FR-1.4                                                |
| **Description**| Service creates an exact copy with "(Copy)" suffix    |
| **Steps**      | 1. Create note with title "Report", body "Content", folder "Work" |
|                | 2. Call `NoteService.duplicate(note, context:)`       |
| **Expected**   | New note: title "Report (Copy)", body "Content", folder "Work", new UUID, `isPinned == false` |
| **Priority**   | Should                                                |

### TC-S1.6: Duplicate Note - Copies Tags

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.6                                               |
| **Requirement**| FR-1.4, FR-2.4                                        |
| **Description**| Duplicated note shares the same tags as the original  |
| **Steps**      | 1. Create note with tags "Urgent" and "Work"          |
|                | 2. Duplicate the note                                 |
| **Expected**   | Duplicate has tags "Urgent" and "Work"                |
| **Priority**   | Could                                                 |

### TC-S1.7: Toggle Pin

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.7                                               |
| **Requirement**| FR-1.5                                                |
| **Description**| Service toggles the isPinned state                    |
| **Steps**      | 1. Create unpinned note                               |
|                | 2. Call `NoteService.togglePin(note)`                 |
| **Expected**   | `note.isPinned == true`                               |
| **Priority**   | Should                                                |

### TC-S1.8: Fetch Notes - By Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.8                                               |
| **Requirement**| FR-2.5                                                |
| **Description**| Fetching notes by folder returns only that folder's notes |
| **Steps**      | 1. Create 3 notes in Folder A, 2 notes in Folder B   |
|                | 2. Call `NoteService.fetchNotes(in: folderA, context:)` |
| **Expected**   | Returns exactly 3 notes                               |
| **Priority**   | Must                                                  |

### TC-S1.9: Fetch Notes - All Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.9                                               |
| **Requirement**| FR-2.5                                                |
| **Description**| Fetching all notes returns every note regardless of folder |
| **Steps**      | 1. Create 3 notes in Folder A, 2 unfiled              |
|                | 2. Call `NoteService.fetchNotes(in: nil, context:)`   |
| **Expected**   | Returns exactly 5 notes                               |
| **Priority**   | Must                                                  |

### TC-S1.10: Fetch Notes - Sorted by ModifiedAt

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.10                                              |
| **Requirement**| UI_DESIGN (newest first)                              |
| **Description**| Fetched notes are sorted by modifiedAt descending     |
| **Steps**      | 1. Create notes at different times                    |
| **Expected**   | First note in result has the latest modifiedAt        |
| **Priority**   | Must                                                  |

### TC-S1.11: Fetch Notes - Pinned First

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.11                                              |
| **Requirement**| FR-1.5                                                |
| **Description**| Pinned notes appear before unpinned in fetch results  |
| **Steps**      | 1. Create 2 unpinned notes, then 1 pinned note (oldest) |
| **Expected**   | Pinned note is first in results                       |
| **Priority**   | Should                                                |

### TC-S1.12: Toggle Pin - Does NOT Update modifiedAt

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.12                                              |
| **Requirement**| CONTRACTS.md (togglePin)                              |
| **Description**| Pinning a note does not change modifiedAt             |
| **Steps**      | 1. Create note, record `modifiedAt`                   |
|                | 2. Call `NoteService.togglePin(note)`                 |
| **Expected**   | `note.isPinned == true`, `modifiedAt` unchanged       |
| **Priority**   | Must                                                  |

### TC-S1.13: Move Note - Does NOT Update modifiedAt

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.13                                              |
| **Requirement**| CONTRACTS.md (moveNote)                               |
| **Description**| Moving a note to a different folder does not change modifiedAt |
| **Steps**      | 1. Create note in Folder A, record `modifiedAt`       |
|                | 2. Call `NoteService.moveNote(note, to: folderB)`     |
| **Expected**   | `note.folder == folderB`, `modifiedAt` unchanged      |
| **Priority**   | Must                                                  |

### TC-S1.14: Fetch Notes - Full Sort Order with Tiebreakers

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.14                                              |
| **Requirement**| EDGE_CASES.md (sorting rules)                         |
| **Description**| Notes with same modifiedAt sort by createdAt then id  |
| **Steps**      | 1. Create 3 notes with identical modifiedAt but different createdAt |
| **Expected**   | Sorted by createdAt descending; if createdAt also equal, by id ascending |
| **Priority**   | Must                                                  |

### TC-S1.15: Duplicate Note - Sequential Copy Numbering

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.15                                              |
| **Requirement**| CONTRACTS.md (duplicate)                              |
| **Description**| Duplicating a note multiple times produces numbered copies |
| **Steps**      | 1. Create note "Report"                               |
|                | 2. Duplicate → "Report (Copy)"                       |
|                | 3. Duplicate original again → "Report (Copy 2)"      |
| **Expected**   | Third duplicate: "Report (Copy 3)"                    |
| **Priority**   | Should                                                |

### TC-S1.16: Title Newline Stripping

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.16                                              |
| **Requirement**| EDGE_CASES.md (Note Title validation)                 |
| **Description**| Newlines in note title are stripped (title is single-line) |
| **Steps**      | 1. Call `NoteService.update(note, title: "Line1\nLine2")` |
| **Expected**   | `note.title == "Line1Line2"` (newlines removed)       |
| **Priority**   | Should                                                |

### TC-S1.17: Title Null Byte Stripping

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.17                                              |
| **Requirement**| EDGE_CASES.md (Note Title validation)                 |
| **Description**| Null bytes in note title are stripped                  |
| **Steps**      | 1. Call `NoteService.update(note, title: "Hello\0World")` |
| **Expected**   | `note.title == "HelloWorld"` (null bytes removed)     |
| **Priority**   | Should                                                |

### TC-S1.18: Folder Reorder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S1.18                                              |
| **Requirement**| CONTRACTS.md (FolderService.reorder)                  |
| **Description**| Reordering folders updates displayOrder for all affected |
| **Steps**      | 1. Create folders A(0), B(1), C(2)                    |
|                | 2. Call `FolderService.reorder(from: 2, to: 0, context:)` |
| **Expected**   | displayOrder: C(0), A(1), B(2)                        |
| **Priority**   | Should                                                |

---

## TC-S2: SearchService

### TC-S2.1: Search Title - Exact Match

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.1                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Searching for an exact title returns that note        |
| **Steps**      | 1. Create notes "Meeting Notes", "Shopping List"      |
|                | 2. Call `SearchService.search("Meeting Notes", context:)` |
| **Expected**   | Returns 1 result: "Meeting Notes"                     |
| **Priority**   | Must                                                  |

### TC-S2.2: Search Title - Partial Match

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.2                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Searching partial text matches titles containing it   |
| **Steps**      | 1. Create notes "Meeting Notes", "Meeting Agenda"     |
|                | 2. Search "Meeting"                                   |
| **Expected**   | Returns 2 results                                     |
| **Priority**   | Must                                                  |

### TC-S2.3: Search Body Content

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.3                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Search matches text in note body, not just title      |
| **Steps**      | 1. Create note titled "Daily Log" with body containing "quarterly review" |
|                | 2. Search "quarterly"                                 |
| **Expected**   | Returns "Daily Log" note                              |
| **Priority**   | Must                                                  |

### TC-S2.4: Search - Case Insensitive

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.4                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Search is case-insensitive                            |
| **Steps**      | 1. Create note titled "URGENT Report"                 |
|                | 2. Search "urgent"                                    |
| **Expected**   | Returns "URGENT Report"                               |
| **Priority**   | Must                                                  |

### TC-S2.5: Search - No Results

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.5                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Searching for non-existent text returns empty results |
| **Steps**      | 1. Create notes "A", "B"                              |
|                | 2. Search "xyz123"                                    |
| **Expected**   | Returns empty array                                   |
| **Priority**   | Must                                                  |

### TC-S2.6: Search - Empty Query

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.6                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Empty search query returns all notes                  |
| **Steps**      | 1. Create 5 notes                                     |
|                | 2. Search ""                                          |
| **Expected**   | Returns all 5 notes                                   |
| **Priority**   | Must                                                  |

### TC-S2.7: Search - Whitespace Only Query

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.7                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Whitespace-only query is treated as empty             |
| **Steps**      | 1. Search "   "                                       |
| **Expected**   | Returns all notes (same as empty query)               |
| **Priority**   | Should                                                |

### TC-S2.8: Search - Scoped to Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.8                                               |
| **Requirement**| FR-3.4                                                |
| **Description**| Search can be scoped to a specific folder             |
| **Steps**      | 1. Create "Budget" in Folder A, "Budget" in Folder B  |
|                | 2. Search "Budget" scoped to Folder A                 |
| **Expected**   | Returns 1 result (only from Folder A)                 |
| **Priority**   | Could                                                 |

### TC-S2.9: Search - Special Characters

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.9                                               |
| **Requirement**| FR-3.1                                                |
| **Description**| Search handles special characters without crashing    |
| **Steps**      | 1. Search for `@#$%^&*()`                             |
| **Expected**   | Returns empty results (no crash)                      |
| **Priority**   | Should                                                |

### TC-S2.10: Search - Markdown Syntax in Body

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S2.10                                              |
| **Requirement**| FR-3.1, FR-4.2                                        |
| **Description**| Search matches plain text within Markdown syntax      |
| **Steps**      | 1. Create note with body `## Important Heading`       |
|                | 2. Search "Important"                                 |
| **Expected**   | Returns the note                                      |
| **Priority**   | Should                                                |

---

## TC-S3: ExportService

### TC-S3.1: Export Note as Markdown

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.1                                               |
| **Requirement**| FR-5.1                                                |
| **Description**| Exporting a note produces a valid `.md` file          |
| **Steps**      | 1. Create note with title "Test" and body "# Hello\n\nWorld" |
|                | 2. Call `ExportService.exportAsMarkdown(note)`        |
| **Expected**   | Returns `Data` with content `# Test\n\n# Hello\n\nWorld`, filename "Test.md" |
| **Priority**   | Must                                                  |

### TC-S3.2: Export Note as Text

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.2                                               |
| **Requirement**| FR-5.2                                                |
| **Description**| Exporting a note produces a plain `.txt` file         |
| **Steps**      | 1. Create note with title "Test" and body "Hello World" |
|                | 2. Call `ExportService.exportAsText(note)`            |
| **Expected**   | Returns `Data` with plain text content, filename "Test.txt" |
| **Priority**   | Should                                                |

### TC-S3.3: Export Note - Filename Sanitization

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.3                                               |
| **Requirement**| FR-5.1                                                |
| **Description**| Note titles with invalid filename characters are sanitized |
| **Steps**      | 1. Create note with title "Meeting: 3/6/2026"         |
|                | 2. Export as Markdown                                  |
| **Expected**   | Filename sanitized (e.g., "Meeting- 3-6-2026.md")     |
| **Priority**   | Should                                                |

### TC-S3.4: Export Note - Empty Body

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.4                                               |
| **Requirement**| FR-5.1                                                |
| **Description**| Exporting a note with empty body produces valid file  |
| **Steps**      | 1. Create note with title "Empty" and body ""         |
|                | 2. Export as Markdown                                  |
| **Expected**   | File contains title header only: `# Empty\n\n`        |
| **Priority**   | Should                                                |

### TC-S3.5: Import Markdown File

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.5                                               |
| **Requirement**| FR-5.3                                                |
| **Description**| Importing a `.md` file creates a new note             |
| **Steps**      | 1. Create a `.md` file with `# My Title\n\nSome body` |
|                | 2. Call `ExportService.importFile(url:, context:)`    |
| **Expected**   | New note created with title "My Title", body "Some body" |
| **Priority**   | Should                                                |

### TC-S3.6: Import Text File

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.6                                               |
| **Requirement**| FR-5.3                                                |
| **Description**| Importing a `.txt` file creates a new note            |
| **Steps**      | 1. Create a `.txt` file with content "Hello World"    |
|                | 2. Call `ExportService.importFile(url:, context:)`    |
| **Expected**   | New note with title from filename, body "Hello World" |
| **Priority**   | Should                                                |

### TC-S3.7: Import - Unsupported File Type

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.7                                               |
| **Requirement**| FR-5.3                                                |
| **Description**| Importing unsupported file type returns error         |
| **Steps**      | 1. Attempt to import a `.pdf` file                    |
| **Expected**   | Returns error indicating unsupported format           |
| **Priority**   | Should                                                |

### TC-S3.8: Import - Empty File

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.8                                               |
| **Requirement**| FR-5.3                                                |
| **Description**| Importing an empty file creates a note with empty body |
| **Steps**      | 1. Import empty `.md` file named "blank.md"           |
| **Expected**   | Note created with title "blank", body ""              |
| **Priority**   | Should                                                |

### TC-S3.9: Import - UTF-8 Encoding

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.9                                               |
| **Requirement**| FR-5.3                                                |
| **Description**| Imported files with Unicode characters are handled    |
| **Steps**      | 1. Import `.md` file containing emoji and CJK chars   |
| **Expected**   | Note body contains all characters correctly           |
| **Priority**   | Should                                                |

### TC-S3.10: Export All Notes as Zip

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.10                                              |
| **Requirement**| FR-5.4                                                |
| **Description**| Exporting all notes creates a zip archive             |
| **Steps**      | 1. Create 5 notes in various folders                  |
|                | 2. Call `ExportService.exportAll(context:)`           |
| **Expected**   | Returns zip `Data` containing 5 `.md` files           |
| **Priority**   | Could                                                 |

### TC-S3.11: Export All - Folder Structure in Zip

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.11                                              |
| **Requirement**| FR-5.4                                                |
| **Description**| Zip export preserves folder structure as directories  |
| **Steps**      | 1. Create "Note1" in "Work" folder, "Note2" unfiled   |
|                | 2. Export all as zip                                  |
| **Expected**   | Zip contains `Work/Note1.md` and `Note2.md`           |
| **Priority**   | Could                                                 |

### TC-S3.12: Export - Duplicate Filenames

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-S3.12                                              |
| **Requirement**| FR-5.1                                                |
| **Description**| Notes with the same title get unique filenames        |
| **Steps**      | 1. Create two notes both titled "Meeting Notes"       |
|                | 2. Export all as zip                                  |
| **Expected**   | Files named `Meeting Notes.md` and `Meeting Notes (Copy).md` |
| **Priority**   | Should                                                |
