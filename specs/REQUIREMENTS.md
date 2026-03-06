# Requirements

## Functional Requirements

### FR-1: Note Management

| ID     | Requirement                                      | Priority |
|--------|--------------------------------------------------|----------|
| FR-1.1 | Create a new note with a single action           | Must     |
| FR-1.2 | Edit note title and body inline                  | Must     |
| FR-1.3 | Delete a note with confirmation                  | Must     |
| FR-1.4 | Duplicate an existing note                       | Should   |
| FR-1.5 | Pin/unpin notes to keep them at the top          | Should   |
| FR-1.6 | Auto-save notes as the user types (no save button) | Must   |

### FR-2: Organization

| ID     | Requirement                                      | Priority |
|--------|--------------------------------------------------|----------|
| FR-2.1 | Organize notes into folders                      | Must     |
| FR-2.2 | Create, rename, and delete folders               | Must     |
| FR-2.3 | Move notes between folders via drag-and-drop     | Should   |
| FR-2.4 | Tag notes with custom labels                     | Could    |
| FR-2.5 | Filter notes by folder or tag                    | Should   |

### FR-3: Search

| ID     | Requirement                                      | Priority |
|--------|--------------------------------------------------|----------|
| FR-3.1 | Full-text search across all notes                | Must     |
| FR-3.2 | Search results highlighted in context            | Should   |
| FR-3.3 | Search as you type with instant results          | Must     |
| FR-3.4 | Search scoped to current folder                  | Could    |

### FR-4: Editor

| ID     | Requirement                                      | Priority |
|--------|--------------------------------------------------|----------|
| FR-4.1 | Plain text editing                               | Must     |
| FR-4.2 | Markdown syntax support                          | Must     |
| FR-4.3 | Toggle between edit and preview modes            | Must     |
| FR-4.4 | Basic formatting toolbar (bold, italic, headings)| Should   |
| FR-4.5 | Code block support with syntax highlighting      | Could    |
| FR-4.6 | Word and character count display                 | Should   |

### FR-5: Import / Export

| ID     | Requirement                                      | Priority |
|--------|--------------------------------------------------|----------|
| FR-5.1 | Export a note as `.md` file                      | Must     |
| FR-5.2 | Export a note as `.txt` file                     | Should   |
| FR-5.3 | Import `.md` and `.txt` files as notes           | Should   |
| FR-5.4 | Export all notes as a zip archive                 | Could    |

### FR-6: Keyboard Shortcuts

| ID     | Requirement                                      | Priority |
|--------|--------------------------------------------------|----------|
| FR-6.1 | `Cmd+N` - New note                              | Must     |
| FR-6.2 | `Cmd+F` - Focus search                          | Must     |
| FR-6.3 | `Cmd+Backspace` - Delete note                   | Must     |
| FR-6.4 | `Cmd+Shift+P` - Toggle Markdown preview         | Should   |
| FR-6.5 | `Cmd+1/2/3` - Switch between sidebar sections   | Could    |

---

## Non-Functional Requirements

### NFR-1: Performance

| ID      | Requirement                                     | Target        |
|---------|-------------------------------------------------|---------------|
| NFR-1.1 | App launch time                                 | < 1 second    |
| NFR-1.2 | Note switching (selection to render)             | < 100ms       |
| NFR-1.3 | Search results returned                          | < 200ms       |
| NFR-1.4 | Memory usage (idle, 100 notes)                   | < 80 MB       |
| NFR-1.5 | Handle up to 10,000 notes without degradation   | Responsive    |

### NFR-2: Usability

| ID      | Requirement                                     |
|---------|-------------------------------------------------|
| NFR-2.1 | Follow macOS Human Interface Guidelines         |
| NFR-2.2 | Support macOS Dark Mode and Light Mode          |
| NFR-2.3 | Support Dynamic Type / accessibility text sizes |
| NFR-2.4 | Full VoiceOver accessibility                    |
| NFR-2.5 | Resizable window with a minimum size of 600x400|

### NFR-3: Reliability

| ID      | Requirement                                     |
|---------|-------------------------------------------------|
| NFR-3.1 | Auto-save prevents data loss on crash           |
| NFR-3.2 | Graceful error handling (no silent data loss)   |
| NFR-3.3 | Data migration between app versions             |

### NFR-4: Security & Privacy

| ID      | Requirement                                     |
|---------|-------------------------------------------------|
| NFR-4.1 | No network calls; fully offline                 |
| NFR-4.2 | No analytics or telemetry                       |
| NFR-4.3 | Data stored in app sandbox only                 |
| NFR-4.4 | Optional: App Lock via macOS system password    |
