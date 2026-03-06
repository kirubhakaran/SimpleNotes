# SimpleNotes

A lightweight, native macOS notes application built with SwiftUI and Swift Data.

## Overview

SimpleNotes is a clean, fast, and distraction-free notes app for macOS. It focuses on simplicity and speed, allowing users to capture thoughts quickly without unnecessary complexity.

## Key Goals

- **Native macOS experience** - Built with SwiftUI, respecting macOS design conventions (sidebar navigation, keyboard shortcuts, dark/light mode)
- **Fast and lightweight** - Instant launch, instant search, minimal resource usage
- **Offline-first** - All data stored locally using Swift Data; no account or internet required
- **Markdown support** - Write in plain text or Markdown with live preview
- **Privacy-focused** - No telemetry, no cloud sync, no tracking; your notes stay on your device

## Tech Stack

| Component       | Technology          |
|-----------------|---------------------|
| Language        | Swift 5.9+          |
| UI Framework    | SwiftUI             |
| Data Layer      | Swift Data          |
| Min. macOS      | macOS 14 (Sonoma)   |
| IDE             | Xcode 15+           |
| Architecture    | MVVM                |

## Documentation

| Document                              | Description                              |
|---------------------------------------|------------------------------------------|
| [REQUIREMENTS.md](REQUIREMENTS.md)    | Functional and non-functional requirements |
| [ARCHITECTURE.md](ARCHITECTURE.md)    | Technical architecture and design        |
| [UI_DESIGN.md](UI_DESIGN.md)          | UI/UX specifications and layouts         |
| [DATA_MODEL.md](DATA_MODEL.md)        | Data model and persistence details       |
| [ROADMAP.md](ROADMAP.md)              | Development phases and milestones        |

### Testing

| Document                                              | Description                              |
|-------------------------------------------------------|------------------------------------------|
| [TEST_STRATEGY.md](TEST_STRATEGY.md)                  | Overall testing strategy and conventions |
| [TEST_CASES.md](TEST_CASES.md)                        | Model layer unit tests (21 cases)        |
| [TEST_CASES_VIEWMODEL.md](TEST_CASES_VIEWMODEL.md)    | ViewModel layer tests (20 cases)         |
| [TEST_CASES_SERVICE.md](TEST_CASES_SERVICE.md)        | Service layer tests (23 cases)           |
| [TEST_CASES_UI.md](TEST_CASES_UI.md)                  | UI, integration, performance & accessibility tests (43 cases) |

**Total: 107 test cases** (55 Must, 43 Should, 9 Could)

## License

MIT License
