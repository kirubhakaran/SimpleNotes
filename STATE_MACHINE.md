# State Machine & Behavioral Contracts

Defines all state transitions and the exact resulting state for every user action.

---

## App States

```
┌─────────────────────────────────────────────────────────┐
│                      App State                          │
├─────────────────────────────────────────────────────────┤
│ selectedFolder: Folder?     (nil = All Notes)           │
│ selectedNote: Note?         (nil = empty editor)        │
│ searchQuery: String         ("" = no active search)     │
│ isPreviewMode: Bool         (false = edit mode)         │
│ pendingDebounce: Timer?     (nil = no pending save)     │
└─────────────────────────────────────────────────────────┘
```

---

## State Transition Rules

### ST-1: Note Selection

| Action | Resulting State |
|--------|----------------|
| Click note in list | `selectedNote = clicked note`, `isPreviewMode` unchanged |
| Create note | `selectedNote = new note`, `isPreviewMode = false`, `searchQuery = ""` |
| Delete selected note | See **ST-2: Post-Delete Selection** |
| Duplicate note | `selectedNote = duplicate note` |
| Import file | `selectedNote = imported note`, `searchQuery = ""` |
| App launch (notes exist) | `selectedNote = first note in list` (pinned first, then newest) |
| App launch (no notes) | `selectedNote = nil` |

### ST-2: Post-Delete Selection

After deleting the currently selected note from a list of N notes at index I:

```
if N == 1 (deleting the only note):
    selectedNote = nil  (show empty state)

else if I < N - 1 (not the last item):
    selectedNote = note at index I  (the "next" note moves up to fill the gap)

else (deleting the last item in the list):
    selectedNote = note at index I - 1  (select the new last item)
```

**Index** refers to the note's position in the **currently visible** sorted list (pinned first, then by modifiedAt descending).

### ST-3: Folder Selection

| Action | Resulting State |
|--------|----------------|
| Click folder in sidebar | `selectedFolder = folder`, `searchQuery = ""`, `selectedNote = first note in folder (or nil)` |
| Click "All Notes" | `selectedFolder = nil`, `searchQuery = ""`, `selectedNote = first note overall (or nil)` |
| Delete selected folder | `selectedFolder = nil` (switch to All Notes), `selectedNote = first note overall (or nil)` |
| Create folder | `selectedFolder = new folder`, `selectedNote = nil` (new folder is empty) |

### ST-4: Search State

| Action | Resulting State |
|--------|----------------|
| Type in search bar | `searchQuery = typed text`, `notes` filtered in real-time, `selectedNote` preserved if still in results, else `selectedNote = first result (or nil)` |
| Clear search (delete text / click X) | `searchQuery = ""`, full note list restored, `selectedNote` preserved if still in list |
| Press Escape in search bar | Same as clear search, focus returns to editor |
| Switch folders while search active | `searchQuery = ""` (search clears on folder change) |
| Create note while search active | `searchQuery = ""` (search clears), new note selected |
| Delete note while search active | Search remains active, post-delete selection within filtered list |

### ST-5: Preview Mode

| Action | Resulting State |
|--------|----------------|
| Toggle preview (Cmd+Shift+P) | `isPreviewMode = !isPreviewMode` |
| Switch to different note | `isPreviewMode` unchanged (persists across note switches) |
| Create new note | `isPreviewMode = false` (always edit new notes) |
| Delete note, new note selected | `isPreviewMode` unchanged |
| App relaunch | `isPreviewMode = false` (always start in edit mode) |
| No note selected | Preview toggle disabled / no-op |

### ST-6: Auto-Save & Debounce

| Action | Resulting State |
|--------|----------------|
| User types in title or body | Start/restart debounce timer (300ms) |
| Debounce timer fires | Save note to Swift Data context |
| Switch to different note while debounce pending | **Immediately save** pending note (flush debounce), then switch |
| Delete note while debounce pending | Cancel debounce, do NOT save, proceed with delete |
| App enters background / will terminate | **Immediately save** all pending debounce (flush) |
| Save fails | Log error, retry once after 1 second. If retry fails, show non-blocking alert. |

**Debounce interval: 300ms**

---

## View State Combinations

### Valid States

| selectedFolder | searchQuery | selectedNote | Editor Shows |
|----------------|-------------|--------------|-------------|
| nil | "" | Note | All Notes, note in editor |
| nil | "" | nil | All Notes, empty editor state |
| nil | "abc" | Note | All Notes filtered by "abc", matching note in editor |
| nil | "abc" | nil | All Notes filtered by "abc", no match selected / empty |
| Folder | "" | Note | Folder notes, note in editor |
| Folder | "" | nil | Folder notes, empty editor (empty folder) |
| Folder | "abc" | Note | Folder notes filtered by "abc", note in editor |
| Folder | "abc" | nil | Folder notes filtered by "abc", no results empty state |

### Empty State Rules

| Condition | List Column Shows | Editor Column Shows |
|-----------|------------------|---------------------|
| No notes exist anywhere | "No Notes Yet — Press Cmd+N to create your first note." | Same message |
| Folder is empty (no notes in folder) | "No Notes — Press Cmd+N to create a note." | Empty state |
| Search has no results | "No results for '<query>' — Try a different search term." | Previous note remains visible (not cleared) |
| No note selected | N/A (list always visible) | "Select a note or press Cmd+N to create one." |

---

## Keyboard Shortcut State Rules

| Shortcut | Context | Behavior |
|----------|---------|----------|
| Cmd+N | Any | Create note in current folder, clear search, select new note |
| Cmd+N | No folder selected | Create unfiled note |
| Cmd+Backspace | Note selected | Show delete confirmation dialog |
| Cmd+Backspace | No note selected | No-op |
| Cmd+F | Any | Focus search bar, select existing search text |
| Cmd+F | Search already focused | No-op (keep focus) |
| Cmd+Shift+P | Note selected | Toggle preview mode |
| Cmd+Shift+P | No note selected | No-op |
| Cmd+Shift+N | Any | Create folder, select it in sidebar |
| Cmd+E | Note selected | Open export save dialog |
| Cmd+E | No note selected | No-op (menu item disabled) |
| Cmd+O | Any | Open import file picker (`.md`, `.txt` only) |
| Cmd+B | Text selected in editor | Wrap with `**...**` |
| Cmd+B | No text selected | Insert `****` with cursor between |
| Cmd+I | Text selected in editor | Wrap with `*...*` |
| Cmd+I | No text selected | Insert `**` with cursor between |
| Cmd+Z | Editor focused | macOS native undo (text-level only) |
| Escape | Search focused | Clear search, return focus to editor |

---

## Confirmation Dialogs

### Delete Note

```
Title:   "Delete Note?"
Message: "Are you sure you want to delete '<note title>'? This cannot be undone."
Buttons: [Cancel] [Delete]  (Delete is destructive style)
Default: Cancel
```

### Delete Folder

```
Title:   "Delete Folder?"
Message: "Are you sure you want to delete '<folder name>'?
          The <N> notes in this folder will not be deleted."
Buttons: [Cancel] [Delete]  (Delete is destructive style)
Default: Cancel
```

### Delete Folder (empty)

```
Title:   "Delete Folder?"
Message: "Are you sure you want to delete '<folder name>'?"
Buttons: [Cancel] [Delete]
Default: Cancel
```

---

## Drag and Drop Rules

| Source | Target | Behavior |
|--------|--------|----------|
| Note row | Folder in sidebar | Move note to that folder |
| Note row | "All Notes" in sidebar | Set note.folder = nil (unfiled) |
| Note row | Same folder it's in | No-op |
| Note row | Editor area | No-op |
| Folder row | Another folder position | Reorder folders (update displayOrder) |
| Folder row | Note list | No-op |
| External `.md`/`.txt` file | Note list | Import file as new note in current folder |
| External other file | Anywhere | No-op (ignore) |

---

## Window State Persistence

| Property | Persisted Across Launches? | Storage |
|----------|---------------------------|---------|
| Window position | Yes | UserDefaults / NSWindow restoration |
| Window size | Yes | UserDefaults / NSWindow restoration |
| Sidebar width | Yes | UserDefaults |
| Note list width | Yes | UserDefaults |
| Selected folder | No | Always starts at "All Notes" |
| Selected note | No | Always starts with first note selected |
| Search query | No | Always starts empty |
| Preview mode | No | Always starts in edit mode |
| Sidebar collapsed | Yes | UserDefaults |
