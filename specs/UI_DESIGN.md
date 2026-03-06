# UI Design Specification

## Layout

The app uses a standard macOS **three-column NavigationSplitView**:

```
┌──────────────────────────────────────────────────────────────────┐
│  SimpleNotes                                          ─  □  ✕   │
├────────────┬───────────────────┬──────────────────────────────────┤
│  SIDEBAR   │   NOTE LIST       │         EDITOR                  │
│  (200px)   │   (250px)         │         (flexible)              │
│            │                   │                                 │
│  ┌──────┐  │  ┌─────────────┐  │  ┌───────────────────────────┐  │
│  │All   │◀─│  │ Search...   │  │  │ Note Title               │  │
│  │Notes │  │  └─────────────┘  │  ├───────────────────────────┤  │
│  └──────┘  │                   │  │                           │  │
│            │  Meeting Notes    │  │  Note body content goes   │  │
│  FOLDERS   │  Today 2:30 PM   │  │  here. Supports Markdown  │  │
│  ──────    │  ───────────────  │  │  formatting...            │  │
│  📁 Work   │  Shopping List    │  │                           │  │
│  📁 Personal│  Yesterday       │  │  ## Heading               │  │
│  📁 Ideas  │  ───────────────  │  │                           │  │
│            │  Project Plan     │  │  - List item 1            │  │
│            │  Mar 3            │  │  - List item 2            │  │
│  + New     │                   │  │                           │  │
│    Folder  │                   │  │                           │  │
│            │                   │  ├───────────────────────────┤  │
│            │                   │  │ 📝 Edit  👁 Preview      │  │
│            │                   │  │ Words: 142  Chars: 891    │  │
└────────────┴───────────────────┴──┴───────────────────────────┴──┘
```

## Column Details

### Sidebar (Column 1)
- **Width**: 200px (collapsible)
- **Contents**:
  - "All Notes" button (shows every note)
  - Folder list with icons
  - "+ New Folder" button at the bottom
- **Interactions**:
  - Click folder to filter note list
  - Right-click folder for context menu (Rename, Delete)
  - Drag-and-drop to reorder folders

### Note List (Column 2)
- **Width**: 250px (resizable)
- **Contents**:
  - Search bar at top
  - Scrollable list of note rows
  - Each row shows: title (bold), first line preview (gray), relative date
  - Pinned notes appear at top with a pin icon
- **Sorting**: By last modified date (newest first)
- **Interactions**:
  - Click to select and open in editor
  - Right-click for context menu (Pin, Duplicate, Move to Folder, Delete)
  - `Cmd+N` to create new note (appears at top, focused)

### Editor (Column 3)
- **Width**: Flexible (fills remaining space)
- **Contents**:
  - Title field (large, editable, no border)
  - Body text area (full height, scrollable)
  - Bottom toolbar: Edit/Preview toggle, word count, character count
- **Interactions**:
  - Type to edit (auto-save on every keystroke with debounce)
  - `Cmd+Shift+P` to toggle Markdown preview
  - Formatting toolbar appears on text selection (bold, italic, code)

## Empty States

### No Notes
```
┌──────────────────────────┐
│                          │
│       📝                 │
│                          │
│   No Notes Yet           │
│   Press Cmd+N to create  │
│   your first note.       │
│                          │
└──────────────────────────┘
```

### No Search Results
```
┌──────────────────────────┐
│                          │
│       🔍                 │
│                          │
│   No results for "xyz"   │
│   Try a different search │
│   term.                  │
│                          │
└──────────────────────────┘
```

## Color Palette

| Element            | Light Mode        | Dark Mode          |
|--------------------|-------------------|--------------------|
| Background         | System background | System background  |
| Sidebar background | `.sidebar`        | `.sidebar`         |
| Selected note      | Accent color/10%  | Accent color/20%   |
| Note title         | Primary label     | Primary label      |
| Note preview text  | Secondary label   | Secondary label    |
| Note date          | Tertiary label    | Tertiary label     |
| Editor background  | `.textBackground`  | `.textBackground`  |
| Accent color       | System blue       | System blue        |

All colors use **semantic system colors** to respect macOS appearance settings automatically.

## Typography

| Element           | Font                          | Size   |
|-------------------|-------------------------------|--------|
| Sidebar folder    | `.body`                       | 13pt   |
| Note row title    | `.headline`                   | 13pt   |
| Note row preview  | `.subheadline`                | 11pt   |
| Note row date     | `.caption`                    | 10pt   |
| Editor title      | `.title`                      | 22pt   |
| Editor body       | `.system(.body, design: .monospaced)` | 14pt |
| Word count        | `.caption`                    | 10pt   |

## Window Specifications

| Property         | Value             |
|------------------|-------------------|
| Minimum size     | 600 x 400 pt     |
| Default size     | 1000 x 650 pt    |
| Title bar style  | Inline            |
| Toolbar style    | Unified           |

## Menu Bar

```
SimpleNotes  File  Edit  View  Format  Window  Help
```

### File Menu
- New Note (`Cmd+N`)
- New Folder (`Cmd+Shift+N`)
- Import... (`Cmd+O`)
- Export Note... (`Cmd+E`)
- Export All Notes...

### View Menu
- Toggle Sidebar (`Cmd+S` - standard macOS)
- Toggle Preview (`Cmd+Shift+P`)
- Sort By > Date Modified / Date Created / Title

### Format Menu
- Bold (`Cmd+B`)
- Italic (`Cmd+I`)
- Heading 1/2/3
- Code Block
- Bullet List
- Numbered List
