# CLAUDE.md

## Project Overview

SimpleNotes is a lightweight, native macOS notes app built with SwiftUI and Swift Data. It follows MVVM architecture with zero external dependencies.

## Tech Stack

- **Language**: Swift 5.9+
- **UI**: SwiftUI
- **Persistence**: Swift Data
- **Min Target**: macOS 14 (Sonoma)
- **IDE**: Xcode 15+
- **Architecture**: MVVM

## Build & Run

```bash
# Build
xcodebuild -scheme SimpleNotes -configuration Debug build

# Run tests
xcodebuild -scheme SimpleNotes -configuration Debug test

# Open in Xcode
open SimpleNotes.xcodeproj
```

## Project Structure

```
SimpleNotes/
├── Models/          # Swift Data @Model classes (Note, Folder, Tag)
├── ViewModels/      # @Observable classes (SidebarViewModel, NoteEditorViewModel)
├── Views/           # SwiftUI views (Sidebar/, NoteList/, Editor/)
├── Services/        # Stateless business logic (NoteService, SearchService, ExportService)
├── Utilities/       # Helpers (MarkdownParser, KeyboardShortcuts)
├── Resources/       # Assets.xcassets
└── Tests/           # ModelTests/, ViewModelTests/, ServiceTests/
```

## Code Conventions

- Follow Swift API Design Guidelines
- Use `@Model` for Swift Data entities
- Use `@Observable` for ViewModels
- ViewModels call Services; Views bind to ViewModels
- Services accept `ModelContext` as parameter (stateless)
- No third-party dependencies
- Use semantic system colors (no hardcoded colors)
- Use SF Symbols for icons

## Naming Conventions

- Test methods: `test_<method>_<scenario>_<expectedResult>()`
- ViewModels: `<Feature>ViewModel`
- Views: `<Feature>View`
- Services: `<Feature>Service`

## Key Design Decisions

- NavigationSplitView for three-column layout
- Auto-save with debounce (no save button)
- Markdown rendered via AttributedString (no dependencies)
- Deleting a folder unfiles its notes (does not delete them)
- All data local, no network calls, no telemetry

## Documentation

Refer to these spec files before implementing:

- `REQUIREMENTS.md` - What to build (MoSCoW prioritized)
- `ARCHITECTURE.md` - How it's structured
- `UI_DESIGN.md` - How it looks (layouts, colors, typography)
- `DATA_MODEL.md` - Data schema and constraints
- `ROADMAP.md` - Build order (Phase 1 first)
- `TEST_STRATEGY.md` - Testing approach
- `TEST_CASES*.md` - Specific test cases per layer

## Development Workflow

1. Follow the phases in `ROADMAP.md` sequentially
2. Implement features per `REQUIREMENTS.md` priority (Must → Should → Could)
3. Write tests alongside code per `TEST_CASES*.md`
4. Match UI to specs in `UI_DESIGN.md`
5. Respect data constraints in `DATA_MODEL.md`
