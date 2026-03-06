# Test Cases: UI, Integration & Performance

End-to-end UI tests (XCUITest), cross-layer integration tests, and performance benchmarks.

---

## TC-UI1: Note Management Workflows

### TC-UI1.1: Create Note via Cmd+N

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.1                                              |
| **Requirement**| FR-1.1, FR-6.1                                        |
| **Description**| Pressing Cmd+N creates a new note and focuses the title |
| **Steps**      | 1. Launch app                                         |
|                | 2. Press `Cmd+N`                                      |
| **Expected**   | New note appears in list, editor shows "Untitled Note" title field focused, cursor in title |
| **Priority**   | Must                                                  |

### TC-UI1.2: Create Note via Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.2                                              |
| **Requirement**| FR-1.1                                                |
| **Description**| File > New Note creates a note                        |
| **Steps**      | 1. Click File menu > New Note                         |
| **Expected**   | Same behavior as Cmd+N                                |
| **Priority**   | Must                                                  |

### TC-UI1.3: Edit Note Inline

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.3                                              |
| **Requirement**| FR-1.2                                                |
| **Description**| Typing in the editor updates the note in real-time    |
| **Steps**      | 1. Create a note                                      |
|                | 2. Click title field, type "My Title"                 |
|                | 3. Click body area, type "My content"                 |
|                | 4. Click a different note, then click back            |
| **Expected**   | Title and body are preserved                          |
| **Priority**   | Must                                                  |

### TC-UI1.4: Delete Note via Cmd+Backspace

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.4                                              |
| **Requirement**| FR-1.3, FR-6.3                                        |
| **Description**| Pressing Cmd+Backspace shows confirmation then deletes |
| **Steps**      | 1. Select a note                                      |
|                | 2. Press `Cmd+Backspace`                              |
|                | 3. Confirm deletion in dialog                         |
| **Expected**   | Note removed from list, next note selected            |
| **Priority**   | Must                                                  |

### TC-UI1.5: Delete Note - Cancel Confirmation

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.5                                              |
| **Requirement**| FR-1.3                                                |
| **Description**| Canceling delete confirmation keeps the note          |
| **Steps**      | 1. Select a note                                      |
|                | 2. Press `Cmd+Backspace`                              |
|                | 3. Click "Cancel" in dialog                           |
| **Expected**   | Note remains in list, still selected                  |
| **Priority**   | Must                                                  |

### TC-UI1.6: Delete Note via Context Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.6                                              |
| **Requirement**| FR-1.3                                                |
| **Description**| Right-click > Delete removes the note                 |
| **Steps**      | 1. Right-click a note in the list                     |
|                | 2. Select "Delete" from context menu                  |
|                | 3. Confirm deletion                                   |
| **Expected**   | Note removed from list                                |
| **Priority**   | Must                                                  |

### TC-UI1.7: Duplicate Note via Context Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.7                                              |
| **Requirement**| FR-1.4                                                |
| **Description**| Right-click > Duplicate creates a copy                |
| **Steps**      | 1. Create note "Original" with body "Content"         |
|                | 2. Right-click > Duplicate                            |
| **Expected**   | New note "Original (Copy)" appears in list with same body |
| **Priority**   | Should                                                |

### TC-UI1.8: Pin Note via Context Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.8                                              |
| **Requirement**| FR-1.5                                                |
| **Description**| Right-click > Pin moves the note to the top of list   |
| **Steps**      | 1. Create 3 notes                                     |
|                | 2. Right-click the last note > Pin                    |
| **Expected**   | Note moves to top with pin indicator visible          |
| **Priority**   | Should                                                |

### TC-UI1.9: Auto-Save on Typing

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI1.9                                              |
| **Requirement**| FR-1.6                                                |
| **Description**| Edits are saved without explicit save action          |
| **Steps**      | 1. Create note, type "Test content"                   |
|                | 2. Force quit app (kill process)                      |
|                | 3. Relaunch app                                       |
| **Expected**   | Note contains "Test content" (or most of it)          |
| **Priority**   | Must                                                  |

---

## TC-UI2: Folder Management Workflows

### TC-UI2.1: Create Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.1                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Clicking "+ New Folder" creates a folder in sidebar   |
| **Steps**      | 1. Click "+ New Folder" in sidebar                    |
| **Expected**   | New folder appears with editable name field focused   |
| **Priority**   | Must                                                  |

### TC-UI2.2: Create Folder via Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.2                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| File > New Folder creates a folder                    |
| **Steps**      | 1. Click File > New Folder (or Cmd+Shift+N)           |
| **Expected**   | Same as clicking "+ New Folder"                       |
| **Priority**   | Must                                                  |

### TC-UI2.3: Rename Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.3                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Right-click > Rename allows editing the folder name   |
| **Steps**      | 1. Right-click folder > Rename                        |
|                | 2. Type "New Name", press Enter                       |
| **Expected**   | Folder name updated to "New Name"                     |
| **Priority**   | Must                                                  |

### TC-UI2.4: Delete Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.4                                              |
| **Requirement**| FR-2.2                                                |
| **Description**| Deleting a folder keeps its notes as unfiled          |
| **Steps**      | 1. Create folder with 2 notes                         |
|                | 2. Right-click folder > Delete                        |
|                | 3. Confirm deletion                                   |
| **Expected**   | Folder removed, 2 notes appear under "All Notes"      |
| **Priority**   | Must                                                  |

### TC-UI2.5: Select Folder Filters Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.5                                              |
| **Requirement**| FR-2.5                                                |
| **Description**| Clicking a folder shows only its notes in the list    |
| **Steps**      | 1. Create Folder A (2 notes), Folder B (3 notes)      |
|                | 2. Click Folder A in sidebar                          |
| **Expected**   | Note list shows exactly 2 notes                       |
| **Priority**   | Must                                                  |

### TC-UI2.6: All Notes Shows Everything

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.6                                              |
| **Requirement**| FR-2.5                                                |
| **Description**| Clicking "All Notes" shows notes from every folder    |
| **Steps**      | 1. Have notes in multiple folders + unfiled            |
|                | 2. Click "All Notes"                                  |
| **Expected**   | Note list shows all notes combined                    |
| **Priority**   | Must                                                  |

### TC-UI2.7: Drag Note to Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI2.7                                              |
| **Requirement**| FR-2.3                                                |
| **Description**| Dragging a note from the list onto a folder moves it  |
| **Steps**      | 1. Create unfiled note                                |
|                | 2. Drag note row onto "Work" folder in sidebar        |
| **Expected**   | Note now appears under "Work" folder                  |
| **Priority**   | Should                                                |

---

## TC-UI3: Search Workflows

### TC-UI3.1: Focus Search via Cmd+F

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI3.1                                              |
| **Requirement**| FR-6.2                                                |
| **Description**| Cmd+F focuses the search bar                          |
| **Steps**      | 1. Press `Cmd+F`                                      |
| **Expected**   | Search bar in note list column is focused with cursor  |
| **Priority**   | Must                                                  |

### TC-UI3.2: Search Filters Notes in Real-Time

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI3.2                                              |
| **Requirement**| FR-3.3                                                |
| **Description**| Typing in search bar filters the note list instantly  |
| **Steps**      | 1. Create notes "Apple", "Banana", "Avocado"          |
|                | 2. Type "A" in search bar                             |
| **Expected**   | List shows "Apple" and "Avocado" only                 |
| **Priority**   | Must                                                  |

### TC-UI3.3: Clear Search Restores Full List

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI3.3                                              |
| **Requirement**| FR-3.3                                                |
| **Description**| Clearing the search bar restores the full note list   |
| **Steps**      | 1. Type "test" in search (filters list)               |
|                | 2. Clear the search bar (delete text or click X)      |
| **Expected**   | Full note list restored                               |
| **Priority**   | Must                                                  |

### TC-UI3.4: Search - No Results Shows Empty State

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI3.4                                              |
| **Requirement**| UI_DESIGN (empty state)                               |
| **Description**| Searching with no matches shows the empty state view  |
| **Steps**      | 1. Type "zzzznonexistent" in search bar               |
| **Expected**   | Empty state shown: "No results for 'zzzznonexistent'" |
| **Priority**   | Must                                                  |

### TC-UI3.5: Search Highlights in Context

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI3.5                                              |
| **Requirement**| FR-3.2                                                |
| **Description**| Matched text is highlighted in note list rows         |
| **Steps**      | 1. Search "meeting"                                   |
| **Expected**   | "meeting" text is highlighted in matching note titles/previews |
| **Priority**   | Should                                                |

---

## TC-UI4: Editor Workflows

### TC-UI4.1: Toggle Markdown Preview

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.1                                              |
| **Requirement**| FR-4.3, FR-6.4                                        |
| **Description**| Cmd+Shift+P toggles between edit and preview modes    |
| **Steps**      | 1. Create note with body `# Hello\n\n**bold text**`   |
|                | 2. Press `Cmd+Shift+P`                                |
| **Expected**   | Preview renders Markdown: "Hello" as heading, "bold text" in bold |
| **Priority**   | Must                                                  |

### TC-UI4.2: Toggle Preview via Button

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.2                                              |
| **Requirement**| FR-4.3                                                |
| **Description**| Clicking Preview button in toolbar toggles preview    |
| **Steps**      | 1. Click "Preview" button in editor toolbar           |
| **Expected**   | Editor switches to rendered Markdown view             |
| **Priority**   | Must                                                  |

### TC-UI4.3: Formatting - Bold

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.3                                              |
| **Requirement**| FR-4.4                                                |
| **Description**| Cmd+B wraps selected text in bold Markdown syntax     |
| **Steps**      | 1. Select text "important"                            |
|                | 2. Press `Cmd+B`                                      |
| **Expected**   | Text becomes `**important**`                          |
| **Priority**   | Should                                                |

### TC-UI4.4: Formatting - Italic

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.4                                              |
| **Requirement**| FR-4.4                                                |
| **Description**| Cmd+I wraps selected text in italic Markdown syntax   |
| **Steps**      | 1. Select text "emphasis"                             |
|                | 2. Press `Cmd+I`                                      |
| **Expected**   | Text becomes `*emphasis*`                             |
| **Priority**   | Should                                                |

### TC-UI4.5: Word and Character Count Display

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.5                                              |
| **Requirement**| FR-4.6                                                |
| **Description**| Bottom toolbar shows accurate word and character counts |
| **Steps**      | 1. Type "Hello world" in note body                    |
| **Expected**   | Toolbar shows "Words: 2  Chars: 11"                   |
| **Priority**   | Should                                                |

### TC-UI4.6: Word Count Updates on Typing

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.6                                              |
| **Requirement**| FR-4.6                                                |
| **Description**| Word/char counts update as the user types             |
| **Steps**      | 1. Type "one" (Words: 1), then type " two" (Words: 2) |
| **Expected**   | Count updates in real-time                            |
| **Priority**   | Should                                                |

### TC-UI4.7: Code Block Rendering

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI4.7                                              |
| **Requirement**| FR-4.5                                                |
| **Description**| Code blocks render with monospace font in preview     |
| **Steps**      | 1. Type ` ```swift\nlet x = 1\n``` ` in body          |
|                | 2. Toggle preview                                     |
| **Expected**   | Code block rendered with monospace font and background |
| **Priority**   | Could                                                 |

---

## TC-UI5: Empty States

### TC-UI5.1: Empty App - No Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI5.1                                              |
| **Requirement**| UI_DESIGN (empty state)                               |
| **Description**| Fresh app shows "No Notes Yet" empty state            |
| **Steps**      | 1. Launch app with no data                            |
| **Expected**   | Note list shows empty state with Cmd+N instruction    |
| **Priority**   | Must                                                  |

### TC-UI5.2: Empty Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI5.2                                              |
| **Requirement**| UI_DESIGN (empty state)                               |
| **Description**| Empty folder shows appropriate empty state            |
| **Steps**      | 1. Create a folder with no notes                      |
|                | 2. Select the folder                                  |
| **Expected**   | Note list shows empty state message                   |
| **Priority**   | Should                                                |

### TC-UI5.3: No Note Selected

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI5.3                                              |
| **Requirement**| UI_DESIGN (empty state)                               |
| **Description**| Editor shows empty state when no note is selected     |
| **Steps**      | 1. Deselect any note (e.g., after deleting the selected one) |
| **Expected**   | Editor area shows empty state / placeholder           |
| **Priority**   | Must                                                  |

---

## TC-UI6: Import / Export Workflows

### TC-UI6.1: Export Note via Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI6.1                                              |
| **Requirement**| FR-5.1                                                |
| **Description**| File > Export Note opens save dialog                  |
| **Steps**      | 1. Select a note                                      |
|                | 2. Click File > Export Note (Cmd+E)                    |
|                | 3. Choose location and save                           |
| **Expected**   | `.md` file saved to chosen location with note content |
| **Priority**   | Must                                                  |

### TC-UI6.2: Import File via Menu

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI6.2                                              |
| **Requirement**| FR-5.3                                                |
| **Description**| File > Import opens file picker for .md/.txt files    |
| **Steps**      | 1. Click File > Import (Cmd+O)                        |
|                | 2. Select a `.md` file                                |
| **Expected**   | New note created from file content, selected in editor |
| **Priority**   | Should                                                |

### TC-UI6.3: Export Note - No Note Selected

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI6.3                                              |
| **Requirement**| FR-5.1                                                |
| **Description**| Export menu item is disabled when no note is selected  |
| **Steps**      | 1. Deselect all notes                                 |
|                | 2. Open File menu                                     |
| **Expected**   | "Export Note" menu item is grayed out / disabled       |
| **Priority**   | Should                                                |

---

## TC-UI7: Keyboard Shortcuts

### TC-UI7.1: Cmd+N Creates Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI7.1                                              |
| **Requirement**| FR-6.1                                                |
| **Description**| Cmd+N shortcut creates a new note from any context    |
| **Steps**      | 1. Focus is in editor body                            |
|                | 2. Press `Cmd+N`                                      |
| **Expected**   | New note created and selected                         |
| **Priority**   | Must                                                  |

### TC-UI7.2: Cmd+F Focuses Search

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI7.2                                              |
| **Requirement**| FR-6.2                                                |
| **Description**| Cmd+F shortcut focuses search from any context        |
| **Steps**      | 1. Focus is in editor                                 |
|                | 2. Press `Cmd+F`                                      |
| **Expected**   | Search bar focused, existing text selected            |
| **Priority**   | Must                                                  |

### TC-UI7.3: Cmd+Backspace Deletes Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI7.3                                              |
| **Requirement**| FR-6.3                                                |
| **Description**| Cmd+Backspace triggers delete with confirmation       |
| **Steps**      | 1. Select a note                                      |
|                | 2. Press `Cmd+Backspace`                              |
| **Expected**   | Confirmation dialog appears                           |
| **Priority**   | Must                                                  |

### TC-UI7.4: Cmd+Shift+P Toggles Preview

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI7.4                                              |
| **Requirement**| FR-6.4                                                |
| **Description**| Cmd+Shift+P toggles Markdown preview mode             |
| **Steps**      | 1. In edit mode, press `Cmd+Shift+P`                  |
|                | 2. Press `Cmd+Shift+P` again                          |
| **Expected**   | Toggles to preview, then back to edit                 |
| **Priority**   | Should                                                |

### TC-UI7.5: Cmd+Shift+N Creates Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI7.5                                              |
| **Requirement**| UI_DESIGN (File menu)                                 |
| **Description**| Cmd+Shift+N creates a new folder                      |
| **Steps**      | 1. Press `Cmd+Shift+N`                                |
| **Expected**   | New folder appears in sidebar with name field focused  |
| **Priority**   | Must                                                  |

---

## TC-UI8: Window and Layout

### TC-UI8.1: Minimum Window Size

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI8.1                                              |
| **Requirement**| NFR-2.5                                               |
| **Description**| Window cannot be resized below 600x400                |
| **Steps**      | 1. Attempt to resize window to 400x300                |
| **Expected**   | Window stops at 600x400 minimum                       |
| **Priority**   | Should                                                |

### TC-UI8.2: Three-Column Layout

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI8.2                                              |
| **Requirement**| ARCHITECTURE (NavigationSplitView)                    |
| **Description**| App displays sidebar, note list, and editor columns   |
| **Steps**      | 1. Launch app at default size                         |
| **Expected**   | Three columns visible: sidebar (200px), list (250px), editor (flexible) |
| **Priority**   | Must                                                  |

### TC-UI8.3: Dark Mode Support

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI8.3                                              |
| **Requirement**| NFR-2.2                                               |
| **Description**| App renders correctly in Dark Mode                    |
| **Steps**      | 1. Switch macOS to Dark Mode                          |
| **Expected**   | All UI elements use dark color scheme, text is readable, no contrast issues |
| **Priority**   | Must                                                  |

### TC-UI8.4: Light Mode Support

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-UI8.4                                              |
| **Requirement**| NFR-2.2                                               |
| **Description**| App renders correctly in Light Mode                   |
| **Steps**      | 1. Switch macOS to Light Mode                         |
| **Expected**   | All UI elements use light color scheme correctly      |
| **Priority**   | Must                                                  |

---

## TC-INT1: Integration Tests

### TC-INT1.1: Create Note in Folder - End to End

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-INT1.1                                             |
| **Requirement**| FR-1.1, FR-2.1                                        |
| **Description**| Full flow from folder selection to note creation to persistence |
| **Steps**      | 1. Create folder via SidebarVM                        |
|                | 2. Select the folder                                  |
|                | 3. Create note via NoteEditorVM                       |
|                | 4. Verify via NoteService fetch                       |
| **Expected**   | Note exists in context with correct folder, timestamps, defaults |
| **Priority**   | Must                                                  |

### TC-INT1.2: Search After Edit - Finds Updated Content

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-INT1.2                                             |
| **Requirement**| FR-1.2, FR-3.1                                        |
| **Description**| Editing a note's body makes it findable by new content |
| **Steps**      | 1. Create note with body "original"                   |
|                | 2. Edit body to "updated special keyword"             |
|                | 3. Search for "special keyword"                       |
| **Expected**   | Search returns the edited note                        |
| **Priority**   | Must                                                  |

### TC-INT1.3: Delete Folder - Notes Remain Searchable

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-INT1.3                                             |
| **Requirement**| DATA_MODEL (cascade), FR-3.1                          |
| **Description**| After deleting a folder, its notes are still searchable |
| **Steps**      | 1. Create folder with note "Quarterly Report"         |
|                | 2. Delete the folder                                  |
|                | 3. Search for "Quarterly"                             |
| **Expected**   | "Quarterly Report" found (folder == nil)              |
| **Priority**   | Must                                                  |

### TC-INT1.4: Import Then Export Roundtrip

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-INT1.4                                             |
| **Requirement**| FR-5.1, FR-5.3                                        |
| **Description**| Importing a file and re-exporting produces the same content |
| **Steps**      | 1. Import a `.md` file with known content             |
|                | 2. Export the created note as `.md`                   |
|                | 3. Compare file contents                              |
| **Expected**   | Exported content matches imported content (title may differ) |
| **Priority**   | Should                                                |

### TC-INT1.5: Pin Note - Persists After Restart

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-INT1.5                                             |
| **Requirement**| FR-1.5, NFR-3.1                                       |
| **Description**| Pinned state persists after app restart               |
| **Steps**      | 1. Pin a note                                         |
|                | 2. Terminate and relaunch app                         |
| **Expected**   | Note is still pinned and appears at top of list       |
| **Priority**   | Should                                                |

### TC-INT1.6: Move Note Between Folders - Updates Both Lists

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-INT1.6                                             |
| **Requirement**| FR-2.3                                                |
| **Description**| Moving a note between folders updates both folder views |
| **Steps**      | 1. Note in Folder A (showing 3 notes)                 |
|                | 2. Move note to Folder B                              |
|                | 3. Select Folder A, then select Folder B              |
| **Expected**   | Folder A shows 2 notes, Folder B shows the moved note |
| **Priority**   | Should                                                |

---

## TC-PERF1: Performance Tests

### TC-PERF1.1: App Launch Time

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-PERF1.1                                            |
| **Requirement**| NFR-1.1                                               |
| **Description**| App launches in under 1 second                        |
| **Method**     | `measure(metrics: [XCTApplicationLaunchMetric()])` in XCUITest |
| **Expected**   | Launch time < 1 second (average over 5 iterations)    |
| **Priority**   | Must                                                  |

### TC-PERF1.2: Note Switching Speed

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-PERF1.2                                            |
| **Requirement**| NFR-1.2                                               |
| **Description**| Selecting a note renders it in under 100ms            |
| **Method**     | Measure time between selection and editor render       |
| **Dataset**    | 100 notes, average note body 500 words                |
| **Expected**   | < 100ms average                                       |
| **Priority**   | Must                                                  |

### TC-PERF1.3: Search Speed

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-PERF1.3                                            |
| **Requirement**| NFR-1.3                                               |
| **Description**| Search returns results in under 200ms                 |
| **Method**     | Measure SearchService response time                    |
| **Dataset**    | 1,000 notes, average body 500 words                   |
| **Expected**   | < 200ms                                               |
| **Priority**   | Must                                                  |

### TC-PERF1.4: Memory Usage - 100 Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-PERF1.4                                            |
| **Requirement**| NFR-1.4                                               |
| **Description**| App uses less than 80MB memory with 100 notes idle    |
| **Method**     | Load 100 notes, measure memory after settling          |
| **Expected**   | < 80 MB resident memory                               |
| **Priority**   | Should                                                |

### TC-PERF1.5: Large Dataset - 10,000 Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-PERF1.5                                            |
| **Requirement**| NFR-1.5                                               |
| **Description**| App remains responsive with 10,000 notes              |
| **Method**     | Load 10,000 notes, measure scroll, search, create     |
| **Expected**   | No UI hangs > 500ms, search < 1s                      |
| **Priority**   | Should                                                |

### TC-PERF1.6: Auto-Save Does Not Block UI

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-PERF1.6                                            |
| **Requirement**| FR-1.6, NFR-1.2                                       |
| **Description**| Auto-save debounce does not cause typing lag          |
| **Method**     | Type rapidly for 10 seconds, measure frame drops       |
| **Expected**   | No dropped frames, typing latency < 16ms              |
| **Priority**   | Must                                                  |

---

## TC-ACC1: Accessibility Tests

### TC-ACC1.1: VoiceOver - Note List Navigation

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-ACC1.1                                             |
| **Requirement**| NFR-2.4                                               |
| **Description**| VoiceOver can navigate the note list                  |
| **Steps**      | 1. Enable VoiceOver                                   |
|                | 2. Navigate to note list                              |
|                | 3. Arrow through notes                                |
| **Expected**   | VoiceOver reads note title, preview text, and date for each note |
| **Priority**   | Should                                                |

### TC-ACC1.2: VoiceOver - Editor Labels

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-ACC1.2                                             |
| **Requirement**| NFR-2.4                                               |
| **Description**| All editor elements have accessibility labels         |
| **Steps**      | 1. Enable VoiceOver                                   |
|                | 2. Tab through editor elements                        |
| **Expected**   | Title field, body area, preview button, word count are all labeled |
| **Priority**   | Should                                                |

### TC-ACC1.3: Dynamic Type

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-ACC1.3                                             |
| **Requirement**| NFR-2.3                                               |
| **Description**| App respects system text size settings                |
| **Steps**      | 1. Increase macOS text size in System Settings        |
|                | 2. Launch app                                         |
| **Expected**   | All text scales appropriately, no truncation or overlap |
| **Priority**   | Should                                                |

---

## TC-ACC2: Additional Accessibility Tests

### TC-ACC2.1: VoiceOver - Folder Note Count

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-ACC2.1                                             |
| **Requirement**| ACCESSIBILITY.md                                      |
| **Description**| VoiceOver reads folder name with note count           |
| **Steps**      | 1. Enable VoiceOver                                   |
|                | 2. Navigate to a folder with 3 notes                  |
| **Expected**   | VoiceOver reads: "{folder name}, 3 notes"             |
| **Priority**   | Should                                                |

### TC-ACC2.2: Reduced Motion

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-ACC2.2                                             |
| **Requirement**| ACCESSIBILITY.md                                      |
| **Description**| Animations are disabled when Reduce Motion is enabled |
| **Steps**      | 1. Enable Reduce Motion in macOS Accessibility        |
|                | 2. Pin a note, delete a note, toggle preview          |
| **Expected**   | All transitions are instant (no animation)            |
| **Priority**   | Should                                                |

---

## TC-EDGE1: Edge Case Tests

### TC-EDGE1.1: Empty State Messages - Exact Text

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.1                                            |
| **Requirement**| STATE_MACHINE.md (Empty State Rules)                  |
| **Description**| Empty state messages match exact spec text            |
| **Steps**      | 1. Launch app with no data                            |
| **Expected**   | "No Notes Yet" and "Press ⌘N to create your first note." |
| **Priority**   | Must                                                  |

### TC-EDGE1.2: Search Scopes to Selected Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.2                                            |
| **Requirement**| STATE_MACHINE.md (ST-4)                               |
| **Description**| Search respects folder selection scope                |
| **Steps**      | 1. Create "Budget" in Folder A and Folder B           |
|                | 2. Select Folder A                                    |
|                | 3. Search "Budget"                                    |
| **Expected**   | Only Folder A's "Budget" note appears                 |
| **Priority**   | Should                                                |

### TC-EDGE1.3: Search Clears on Folder Switch

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.3                                            |
| **Requirement**| STATE_MACHINE.md (ST-4)                               |
| **Description**| Switching folders while search is active clears the search |
| **Steps**      | 1. Search "test" while in Folder A                    |
|                | 2. Click Folder B in sidebar                          |
| **Expected**   | Search bar cleared, Folder B shows all its notes      |
| **Priority**   | Must                                                  |

### TC-EDGE1.4: Preview Mode Persists Across Note Switches

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.4                                            |
| **Requirement**| STATE_MACHINE.md (ST-5)                               |
| **Description**| Preview mode stays active when selecting a different note |
| **Steps**      | 1. Toggle preview mode on Note A                      |
|                | 2. Click Note B in the list                           |
| **Expected**   | Note B shown in preview mode                          |
| **Priority**   | Must                                                  |

### TC-EDGE1.5: Preview Mode Resets on New Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.5                                            |
| **Requirement**| STATE_MACHINE.md (ST-5)                               |
| **Description**| Creating a new note always opens in edit mode         |
| **Steps**      | 1. Toggle preview mode on                             |
|                | 2. Press Cmd+N                                        |
| **Expected**   | New note opens in edit mode (`isPreviewMode == false`) |
| **Priority**   | Must                                                  |

### TC-EDGE1.6: Debounce Flush on Note Switch

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.6                                            |
| **Requirement**| STATE_MACHINE.md (ST-6)                               |
| **Description**| Switching notes immediately saves pending edits       |
| **Steps**      | 1. Type in Note A (debounce starts)                   |
|                | 2. Immediately click Note B (before 300ms)            |
|                | 3. Click back to Note A                               |
| **Expected**   | Note A has all typed content (debounce was flushed)   |
| **Priority**   | Must                                                  |

### TC-EDGE1.7: Save Failure Retry

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.7                                            |
| **Requirement**| STATE_MACHINE.md (ST-6), EDGE_CASES.md                |
| **Description**| Save failure triggers retry and shows appropriate messages |
| **Steps**      | 1. Simulate save failure                              |
| **Expected**   | Banner: "Unable to save. Retrying..." → retry after 1s → if still fails: "Save failed. Your changes may not be persisted." |
| **Priority**   | Should                                                |

### TC-EDGE1.8: Word Count with Markdown

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.8                                            |
| **Requirement**| EDGE_CASES.md (Word Count Rules)                      |
| **Description**| Markdown syntax tokens count as words                 |
| **Steps**      | 1. Set body to `"## Heading"` → Word count            |
|                | 2. Set body to `"**bold**"` → Word count              |
| **Expected**   | `## Heading` = 2 words, `**bold**` = 1 word           |
| **Priority**   | Should                                                |

### TC-EDGE1.9: Delete Folder Switches to All Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.9                                            |
| **Requirement**| STATE_MACHINE.md (ST-3)                               |
| **Description**| Deleting the selected folder switches to All Notes view |
| **Steps**      | 1. Select Folder A (with notes)                       |
|                | 2. Delete Folder A                                    |
| **Expected**   | `selectedFolder == nil`, All Notes view shown, first note selected |
| **Priority**   | Must                                                  |

### TC-EDGE1.10: Import File Into Specific Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-EDGE1.10                                           |
| **Requirement**| CONTRACTS.md (importFile)                             |
| **Description**| Importing a file while a folder is selected assigns it to that folder |
| **Steps**      | 1. Select Folder "Work"                               |
|                | 2. Import a `.md` file                                |
| **Expected**   | Imported note has `folder == "Work"`                  |
| **Priority**   | Should                                                |

---

## Test Case Summary

| Category       | Count | Must | Should | Could |
|----------------|-------|------|--------|-------|
| Models         | 21    | 12   | 5      | 4     |
| ViewModels     | 20    | 10   | 9      | 1     |
| Services       | 30    | 10   | 17     | 3     |
| UI Workflows   | 28    | 19   | 8      | 1     |
| Integration    | 6     | 3    | 3      | 0     |
| Performance    | 6     | 3    | 3      | 0     |
| Accessibility  | 5     | 0    | 5      | 0     |
| Edge Cases     | 10    | 6    | 4      | 0     |
| **Total**      | **126** | **63** | **54** | **9** |
