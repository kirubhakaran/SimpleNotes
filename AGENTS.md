# AGENTS.md

## Project

SimpleNotes — a lightweight, native macOS notes app built with SwiftUI and Swift Data. MVVM architecture, zero external dependencies.

## Stack

- Swift 5.9+, SwiftUI, Swift Data
- macOS 14+ (Sonoma)
- Xcode 15+
- MVVM pattern

## Build Commands

```bash
xcodebuild -scheme SimpleNotes -configuration Debug build
xcodebuild -scheme SimpleNotes -configuration Debug test
open SimpleNotes.xcodeproj
```

## Structure

```
SimpleNotes/
├── Models/          # Swift Data @Model classes (Note, Folder, Tag)
├── ViewModels/      # @Observable classes (SidebarViewModel, NoteEditorViewModel)
├── Views/
│   ├── Sidebar/     # SidebarView, FolderRow
│   ├── NoteList/    # NoteListView, NoteRow
│   └── Editor/      # NoteEditorView, MarkdownPreview, EditorToolbar
├── Services/        # NoteService, SearchService, ExportService
├── Utilities/       # MarkdownParser, KeyboardShortcuts
├── Resources/       # Assets.xcassets
└── Tests/           # ModelTests/, ViewModelTests/, ServiceTests/
```

## Rules

- Follow Swift API Design Guidelines
- Use `@Model` for data entities, `@Observable` for ViewModels
- Views bind to ViewModels; ViewModels call Services; Services operate on ModelContext
- Services are stateless — pass ModelContext as parameter
- No third-party dependencies allowed
- Use semantic system colors only (no hardcoded hex in views)
- Use SF Symbols for all icons
- Auto-save with debounce, no save button
- Markdown rendered via native AttributedString
- Deleting a folder sets its notes' folder to nil (does not delete notes)
- All data local — no network calls, no analytics, no telemetry
- NavigationSplitView for three-column layout

## Naming

- Tests: `test_<method>_<scenario>_<expectedResult>()`
- ViewModels: `<Feature>ViewModel`
- Views: `<Feature>View`
- Services: `<Feature>Service`

## Spec Files

Read these before implementing:

- `specs/REQUIREMENTS.md` — functional and non-functional requirements (MoSCoW priority)
- `specs/ARCHITECTURE.md` — MVVM layers, project structure, data flow
- `specs/UI_DESIGN.md` — three-column layout, colors, typography, menus
- `specs/DATA_MODEL.md` — Note/Folder/Tag schema, relationships, constraints
- `specs/ROADMAP.md` — 6 development phases (build Phase 1 first)
- `specs/behavior/CONTRACTS.md` — API method signatures, error types, return contracts
- `specs/behavior/STATE_MACHINE.md` — state transitions, post-action behavior, confirmation dialogs
- `specs/behavior/EDGE_CASES.md` — validation rules, sorting tiebreakers, concurrency model, constants
- `specs/accessibility/ACCESSIBILITY.md` — VoiceOver labels, focus order, Dynamic Type, Reduced Motion
- `specs/accessibility/LOCALIZATION.md` — string catalog, date/number formatting (all user-facing strings)
- `specs/testing/TEST_STRATEGY.md` — test pyramid, conventions, coverage targets
- `specs/testing/TEST_CASES.md` — model layer tests (21 cases)
- `specs/testing/TEST_CASES_VIEWMODEL.md` — ViewModel tests (20 cases)
- `specs/testing/TEST_CASES_SERVICE.md` — service layer tests (23 cases)
- `specs/testing/TEST_CASES_UI.md` — UI, integration, performance tests (43 cases)

## Critical Rules

- Debounce interval is **300ms** (all constants in `specs/behavior/EDGE_CASES.md`)
- Use `SimpleNotesError` enum from `specs/behavior/CONTRACTS.md` for all thrown errors
- Follow post-delete selection logic in `specs/behavior/STATE_MACHINE.md` ST-2
- Search clears on folder switch; preview mode persists across note switches
- Flush pending debounce saves before note switch or app termination
- All sorting must include tiebreakers (see `specs/behavior/EDGE_CASES.md` Sorting Rules)
- Never hardcode user-facing strings; use `String(localized:)` per `specs/accessibility/LOCALIZATION.md`
- All interactive elements must have accessibility labels per `specs/accessibility/ACCESSIBILITY.md`

## Workflow

1. Follow phases in `specs/ROADMAP.md` sequentially
2. Prioritize Must → Should → Could from `specs/REQUIREMENTS.md`
3. Write tests alongside code per `specs/testing/TEST_CASES*.md`
4. Match UI to `specs/UI_DESIGN.md` specs
5. Respect data constraints in `specs/DATA_MODEL.md`
