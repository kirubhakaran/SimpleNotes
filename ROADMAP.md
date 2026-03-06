# Development Roadmap

## Phase 1: Core MVP

**Goal**: Functional notes app with basic CRUD and navigation.

- [ ] Set up Xcode project with SwiftUI + Swift Data
- [ ] Define data models (Note, Folder)
- [ ] Implement NavigationSplitView layout (three-column)
- [ ] Create note (Cmd+N)
- [ ] Edit note title and body inline
- [ ] Delete note with confirmation (Cmd+Backspace)
- [ ] Note list sorted by modification date
- [ ] Auto-save on edit (debounced)
- [ ] Empty state views

**Exit criteria**: User can create, edit, and delete notes in a three-column layout.

---

## Phase 2: Organization

**Goal**: Folders and basic search.

- [ ] Create, rename, delete folders
- [ ] Assign notes to folders
- [ ] "All Notes" view
- [ ] Full-text search bar in note list
- [ ] Search-as-you-type with instant filtering
- [ ] Pin/unpin notes

**Exit criteria**: User can organize notes into folders and find notes via search.

---

## Phase 3: Markdown & Editor Polish

**Goal**: Markdown support and a polished editing experience.

- [ ] Markdown rendering via AttributedString
- [ ] Edit / Preview toggle (Cmd+Shift+P)
- [ ] Formatting toolbar (bold, italic, headings)
- [ ] Code block support
- [ ] Word and character count in status bar
- [ ] Proper monospaced font in editor

**Exit criteria**: User can write Markdown and preview rendered output.

---

## Phase 4: Import / Export

**Goal**: Get data in and out of the app.

- [ ] Export single note as `.md`
- [ ] Export single note as `.txt`
- [ ] Import `.md` / `.txt` files as new notes
- [ ] Export all notes as `.zip`

**Exit criteria**: User can import and export notes in standard formats.

---

## Phase 5: Polish & Accessibility

**Goal**: Production-quality UX.

- [ ] Dark Mode / Light Mode full verification
- [ ] VoiceOver accessibility audit
- [ ] Dynamic Type support
- [ ] Drag-and-drop notes between folders
- [ ] Context menus (right-click) on notes and folders
- [ ] Keyboard shortcut discoverability (menu bar)
- [ ] Window size and position persistence
- [ ] App icon design

**Exit criteria**: App meets macOS Human Interface Guidelines and passes accessibility audit.

---

## Phase 6: Tags & Advanced Features (Optional)

**Goal**: Extended organization capabilities.

- [ ] Tag model and UI
- [ ] Tag notes from editor
- [ ] Filter by tag
- [ ] Duplicate note
- [ ] Note sorting options (date created, title, date modified)
- [ ] Scoped search (within folder)
- [ ] App Lock (system password)

**Exit criteria**: Power users can leverage tags and advanced features.

---

## Out of Scope (for v1)

These features are explicitly **not** planned for the initial release:

- Cloud sync / iCloud
- Collaboration / sharing
- Image or file attachments
- Rich text (WYSIWYG) editing
- iOS / iPadOS version
- Reminders or due dates
- Nested folders
- Note versioning / history
