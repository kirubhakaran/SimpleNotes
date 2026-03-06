# Architecture

## Overview

SimpleNotes follows the **MVVM (Model-View-ViewModel)** pattern, leveraging SwiftUI's declarative UI and Swift Data for persistence.

```
┌─────────────────────────────────────────────────┐
│                    Views (SwiftUI)               │
│  ┌──────────┐  ┌──────────────┐  ┌───────────┐  │
│  │ Sidebar  │  │  Note List   │  │  Editor   │  │
│  └────┬─────┘  └──────┬───────┘  └─────┬─────┘  │
│       │               │               │         │
├───────┼───────────────┼───────────────┼─────────┤
│       ▼               ▼               ▼         │
│              ViewModels (ObservableObject)       │
│  ┌──────────────┐  ┌──────────────────────────┐  │
│  │ SidebarVM    │  │  NoteEditorVM            │  │
│  └──────┬───────┘  └────────────┬─────────────┘  │
│         │                      │                │
├─────────┼──────────────────────┼────────────────┤
│         ▼                      ▼                │
│                  Services                       │
│  ┌──────────────┐  ┌──────────────┐             │
│  │ NoteService  │  │SearchService │             │
│  └──────┬───────┘  └──────┬───────┘             │
│         │                 │                     │
├─────────┼─────────────────┼─────────────────────┤
│         ▼                 ▼                     │
│              Models (Swift Data)                │
│  ┌──────┐  ┌────────┐  ┌─────┐                  │
│  │ Note │  │ Folder │  │ Tag │                  │
│  └──────┘  └────────┘  └─────┘                  │
└─────────────────────────────────────────────────┘
```

## Project Structure

```
SimpleNotes/
├── SimpleNotesApp.swift            # App entry point
├── Models/
│   ├── Note.swift                  # Note model
│   ├── Folder.swift                # Folder model
│   └── Tag.swift                   # Tag model
├── ViewModels/
│   ├── SidebarViewModel.swift      # Sidebar state & logic
│   └── NoteEditorViewModel.swift   # Editor state & logic
├── Views/
│   ├── ContentView.swift           # Main NavigationSplitView
│   ├── Sidebar/
│   │   ├── SidebarView.swift       # Folder list + All Notes
│   │   └── FolderRow.swift         # Single folder row
│   ├── NoteList/
│   │   ├── NoteListView.swift      # List of notes in a folder
│   │   └── NoteRow.swift           # Single note row (title + date)
│   └── Editor/
│       ├── NoteEditorView.swift    # Main editor area
│       ├── MarkdownPreview.swift   # Rendered Markdown view
│       └── EditorToolbar.swift     # Formatting toolbar
├── Services/
│   ├── NoteService.swift           # CRUD operations for notes
│   ├── SearchService.swift         # Full-text search logic
│   └── ExportService.swift         # Import/export functionality
├── Utilities/
│   ├── MarkdownParser.swift        # Markdown-to-AttributedString
│   └── KeyboardShortcuts.swift     # Shortcut definitions
├── Resources/
│   └── Assets.xcassets             # App icons, colors
└── Tests/
    ├── ModelTests/
    ├── ViewModelTests/
    └── ServiceTests/
```

## Layer Responsibilities

### Models
- Swift Data `@Model` classes defining the schema
- No business logic; pure data containers
- Relationships managed via Swift Data (e.g., `Folder` has many `Note`)

### ViewModels
- `@Observable` classes that hold view state
- Call into Services for data operations
- Expose published properties for SwiftUI bindings
- Handle input validation and state transitions

### Views
- Pure SwiftUI views; no direct data access
- Bind to ViewModel properties
- Use `NavigationSplitView` for the three-column layout

### Services
- Stateless classes that perform operations on the data layer
- Accept a `ModelContext` and operate on it
- Contain business rules (e.g., search ranking, export formatting)

## Key Design Decisions

| Decision                  | Choice              | Rationale                                        |
|---------------------------|---------------------|--------------------------------------------------|
| Persistence               | Swift Data           | Native Apple framework, seamless SwiftUI integration |
| Architecture              | MVVM                 | Clean separation of concerns, testable ViewModels   |
| Layout                    | NavigationSplitView  | Standard macOS three-column pattern                 |
| Markdown rendering        | AttributedString     | Native, no third-party dependency                   |
| Min deployment target     | macOS 14 (Sonoma)    | Required for Swift Data and latest SwiftUI APIs      |
| Dependency management     | None (zero deps)     | Keeps app lightweight and maintainable              |

## Data Flow

```
User Action (View)
    │
    ▼
ViewModel receives action
    │
    ▼
ViewModel calls Service method
    │
    ▼
Service performs operation on ModelContext
    │
    ▼
Swift Data persists changes automatically
    │
    ▼
SwiftUI re-renders via @Query / @Observable
```
