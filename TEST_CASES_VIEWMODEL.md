# Test Cases: ViewModels

Unit tests for `SidebarViewModel` and `NoteEditorViewModel`.

---

## TC-VM1: SidebarViewModel

### TC-VM1.1: Load Folders

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.1                                              |
| **Requirement**| FR-2.1                                                |
| **Description**| ViewModel loads all folders sorted by displayOrder    |
| **Precondition** | 3 folders exist in context with different displayOrder |
| **Steps**      | 1. Initialize SidebarViewModel with context           |
| **Expected**   | `folders.count == 3`, sorted by `displayOrder` ascending |
| **Priority**   | Must                                                  |

### TC-VM1.2: Create Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.2                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Creating a folder adds it to the list                 |
| **Steps**      | 1. Call `createFolder(name: "Projects")`              |
| **Expected**   | New folder appears in `folders` with name "Projects"  |
| **Priority**   | Must                                                  |

### TC-VM1.3: Create Folder - Empty Name Defaults

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.3                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Creating folder with empty name defaults to "New Folder" |
| **Steps**      | 1. Call `createFolder(name: "")`                      |
| **Expected**   | Folder created with name "New Folder"                 |
| **Priority**   | Should                                                |

### TC-VM1.4: Rename Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.4                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Renaming a folder updates its name                    |
| **Steps**      | 1. Create folder "Old Name"                           |
|                | 2. Call `renameFolder(folder, to: "New Name")`        |
| **Expected**   | `folder.name == "New Name"`                           |
| **Priority**   | Must                                                  |

### TC-VM1.5: Rename Folder - Whitespace Only Name

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.5                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Renaming folder to whitespace-only is rejected        |
| **Steps**      | 1. Call `renameFolder(folder, to: "   ")`             |
| **Expected**   | Folder name remains unchanged                         |
| **Priority**   | Should                                                |

### TC-VM1.6: Delete Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.6                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Deleting a folder removes it from the list            |
| **Steps**      | 1. Create folder, note count = 1                      |
|                | 2. Call `deleteFolder(folder)`                        |
| **Expected**   | Folder removed from `folders`, note still exists with `folder == nil` |
| **Priority**   | Must                                                  |

### TC-VM1.7: Select Folder - Filters Note List

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.7                                              |
| **Requirement**| FR-2.5                                                |
| **Description**| Selecting a folder updates the selected state         |
| **Steps**      | 1. Set `selectedFolder = folderA`                     |
| **Expected**   | `selectedFolder == folderA`                           |
| **Priority**   | Must                                                  |

### TC-VM1.8: Select "All Notes"

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.8                                              |
| **Requirement**| FR-2.5                                                |
| **Description**| Setting selectedFolder to nil shows all notes         |
| **Steps**      | 1. Set `selectedFolder = nil`                         |
| **Expected**   | `selectedFolder == nil` (All Notes mode)              |
| **Priority**   | Must                                                  |

### TC-VM1.9: Reorder Folders

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM1.9                                              |
| **Requirement**| UI_DESIGN (drag to reorder)                           |
| **Description**| Reordering folders updates displayOrder values        |
| **Steps**      | 1. Create folders A(0), B(1), C(2)                    |
|                | 2. Call `moveFolder(from: 0, to: 2)`                  |
| **Expected**   | displayOrder: B(0), C(1), A(2)                        |
| **Priority**   | Should                                                |

---

## TC-VM2: NoteEditorViewModel

### TC-VM2.1: Create Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.1                                              |
| **Requirement**| FR-1.1                                                |
| **Description**| Creating a note via ViewModel adds it and selects it  |
| **Steps**      | 1. Call `createNote()`                                |
| **Expected**   | New note created, `selectedNote == newNote`, title is "Untitled Note" |
| **Priority**   | Must                                                  |

### TC-VM2.2: Create Note - In Folder Context

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.2                                              |
| **Requirement**| FR-1.1, FR-2.1                                        |
| **Description**| Creating a note while a folder is selected assigns it to that folder |
| **Steps**      | 1. Set `selectedFolder = workFolder`                  |
|                | 2. Call `createNote()`                                |
| **Expected**   | `newNote.folder == workFolder`                        |
| **Priority**   | Must                                                  |

### TC-VM2.3: Edit Title

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.3                                              |
| **Requirement**| FR-1.2                                                |
| **Description**| Updating the title property persists the change       |
| **Steps**      | 1. Select a note                                      |
|                | 2. Set `title = "Updated Title"`                      |
| **Expected**   | `selectedNote.title == "Updated Title"`, `modifiedAt` updated |
| **Priority**   | Must                                                  |

### TC-VM2.4: Edit Body

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.4                                              |
| **Requirement**| FR-1.2                                                |
| **Description**| Updating the body property persists the change        |
| **Steps**      | 1. Select a note                                      |
|                | 2. Set `body = "New content here"`                    |
| **Expected**   | `selectedNote.body == "New content here"`, `modifiedAt` updated |
| **Priority**   | Must                                                  |

### TC-VM2.5: Auto-Save Debounce

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.5                                              |
| **Requirement**| FR-1.6                                                |
| **Description**| Rapid edits are debounced before saving               |
| **Steps**      | 1. Type 10 characters rapidly (within 300ms)          |
| **Expected**   | Save occurs once after debounce period, not 10 times  |
| **Priority**   | Must                                                  |

### TC-VM2.6: Delete Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.6                                              |
| **Requirement**| FR-1.3                                                |
| **Description**| Deleting a note removes it and clears selection       |
| **Steps**      | 1. Select a note                                      |
|                | 2. Call `deleteNote()`                                |
| **Expected**   | Note removed from context, `selectedNote == nil`      |
| **Priority**   | Must                                                  |

### TC-VM2.7: Delete Note - Selects Adjacent

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.7                                              |
| **Requirement**| FR-1.3                                                |
| **Description**| After deleting, the next note in the list is selected |
| **Steps**      | 1. Create notes A, B, C; select B                     |
|                | 2. Delete B                                           |
| **Expected**   | `selectedNote == C` (next note fills gap at same index per STATE_MACHINE ST-2) |
| **Priority**   | Should                                                |

### TC-VM2.8: Delete Last Note - Shows Empty State

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.8                                              |
| **Requirement**| FR-1.3, UI_DESIGN (empty state)                       |
| **Description**| Deleting the only note shows empty state              |
| **Steps**      | 1. Create single note, select it                      |
|                | 2. Delete the note                                    |
| **Expected**   | `selectedNote == nil`, `notes.isEmpty == true`        |
| **Priority**   | Must                                                  |

### TC-VM2.9: Duplicate Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.9                                              |
| **Requirement**| FR-1.4                                                |
| **Description**| Duplicating a note creates a copy with modified title |
| **Steps**      | 1. Select note titled "Meeting Notes"                 |
|                | 2. Call `duplicateNote()`                             |
| **Expected**   | New note with title "Meeting Notes (Copy)", same body, same folder, new ID, new timestamps |
| **Priority**   | Should                                                |

### TC-VM2.10: Pin Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.10                                             |
| **Requirement**| FR-1.5                                                |
| **Description**| Pinning a note sets isPinned and reorders the list    |
| **Steps**      | 1. Create 3 notes, pin the last one                   |
|                | 2. Call `togglePin(note)`                             |
| **Expected**   | `note.isPinned == true`, note appears first in list   |
| **Priority**   | Should                                                |

### TC-VM2.11: Unpin Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.11                                             |
| **Requirement**| FR-1.5                                                |
| **Description**| Unpinning a pinned note sorts it by date again        |
| **Steps**      | 1. Pin a note, then call `togglePin(note)` again      |
| **Expected**   | `note.isPinned == false`, note sorted by modifiedAt   |
| **Priority**   | Should                                                |

### TC-VM2.12: Toggle Preview Mode

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.12                                             |
| **Requirement**| FR-4.3                                                |
| **Description**| Toggling preview mode switches the editor state       |
| **Steps**      | 1. `isPreviewMode == false` (default)                 |
|                | 2. Call `togglePreview()`                             |
| **Expected**   | `isPreviewMode == true`                               |
| **Priority**   | Must                                                  |

### TC-VM2.13: Word Count Calculation

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.13                                             |
| **Requirement**| FR-4.6                                                |
| **Description**| Word count is correctly computed from body text       |
| **Steps**      | 1. Set body to "Hello world, this is a test"          |
| **Expected**   | `wordCount == 6`                                      |
| **Priority**   | Should                                                |

### TC-VM2.14: Character Count Calculation

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.14                                             |
| **Requirement**| FR-4.6                                                |
| **Description**| Character count is correctly computed from body text  |
| **Steps**      | 1. Set body to "Hello"                                |
| **Expected**   | `characterCount == 5`                                 |
| **Priority**   | Should                                                |

### TC-VM2.15: Word Count - Empty Body

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.15                                             |
| **Requirement**| FR-4.6                                                |
| **Description**| Word count is zero for empty body                     |
| **Steps**      | 1. Set body to ""                                     |
| **Expected**   | `wordCount == 0`, `characterCount == 0`               |
| **Priority**   | Should                                                |

### TC-VM2.16: Note List Sorting - By Modified Date

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.16                                             |
| **Requirement**| UI_DESIGN (newest first)                              |
| **Description**| Notes are sorted by modifiedAt descending             |
| **Steps**      | 1. Create notes A (oldest), B, C (newest)             |
| **Expected**   | List order: C, B, A                                   |
| **Priority**   | Must                                                  |

### TC-VM2.17: Note List Sorting - Pinned Notes First

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.17                                             |
| **Requirement**| FR-1.5, UI_DESIGN                                     |
| **Description**| Pinned notes appear before unpinned notes             |
| **Steps**      | 1. Create notes A (unpinned, newest), B (pinned, oldest) |
| **Expected**   | List order: B (pinned), A (unpinned)                  |
| **Priority**   | Should                                                |

### TC-VM2.18: Select Note - No Note Selected

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.18                                             |
| **Requirement**| UI_DESIGN (empty state)                               |
| **Description**| When no note is selected, editor shows empty state    |
| **Steps**      | 1. Set `selectedNote = nil`                           |
| **Expected**   | `isEditorEmpty == true`                               |
| **Priority**   | Must                                                  |

### TC-VM2.19: Move Note to Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.19                                             |
| **Requirement**| FR-2.3                                                |
| **Description**| Moving a note to a different folder updates the relationship |
| **Steps**      | 1. Note in Folder A                                   |
|                | 2. Call `moveNote(note, to: folderB)`                 |
| **Expected**   | `note.folder == folderB`                              |
| **Priority**   | Should                                                |

### TC-VM2.20: Move Note to Unfiled

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-VM2.20                                             |
| **Requirement**| FR-2.3                                                |
| **Description**| Moving a note to nil removes it from its folder       |
| **Steps**      | 1. Note in Folder A                                   |
|                | 2. Call `moveNote(note, to: nil)`                     |
| **Expected**   | `note.folder == nil`                                  |
| **Priority**   | Should                                                |
