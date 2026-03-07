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

| Document                                                      | Description                              |
|---------------------------------------------------------------|------------------------------------------|
| [REQUIREMENTS.md](specs/REQUIREMENTS.md)                      | Functional and non-functional requirements |
| [ARCHITECTURE.md](specs/ARCHITECTURE.md)                      | Technical architecture and design        |
| [UI_DESIGN.md](specs/UI_DESIGN.md)                            | UI/UX specifications and layouts         |
| [DATA_MODEL.md](specs/DATA_MODEL.md)                          | Data model and persistence details       |
| [ROADMAP.md](specs/ROADMAP.md)                                | Development phases and milestones        |

### Contracts & Behavior

| Document                                                                  | Description                              |
|---------------------------------------------------------------------------|------------------------------------------|
| [CONTRACTS.md](specs/behavior/CONTRACTS.md)                               | API contracts, method signatures, error types |
| [STATE_MACHINE.md](specs/behavior/STATE_MACHINE.md)                       | State transitions, behavioral rules, dialogs |
| [EDGE_CASES.md](specs/behavior/EDGE_CASES.md)                             | Validation, sorting, concurrency, configuration |
| [ACCESSIBILITY.md](specs/accessibility/ACCESSIBILITY.md)                  | VoiceOver labels, focus order, Dynamic Type, Reduced Motion |
| [LOCALIZATION.md](specs/accessibility/LOCALIZATION.md)                    | i18n strategy, string catalog, date/number formatting |
| [SPEC_COMPLIANCE.md](specs/SPEC_COMPLIANCE.md)                            | **Mandatory** spec-code consistency rules, check-in checklist |

### Testing

| Document                                                                          | Description                              |
|-----------------------------------------------------------------------------------|------------------------------------------|
| [TEST_STRATEGY.md](specs/testing/TEST_STRATEGY.md)                                | Overall testing strategy and conventions |
| [TEST_CASES.md](specs/testing/TEST_CASES.md)                                      | Model layer unit tests (21 cases)        |
| [TEST_CASES_VIEWMODEL.md](specs/testing/TEST_CASES_VIEWMODEL.md)                  | ViewModel layer tests (20 cases)         |
| [TEST_CASES_SERVICE.md](specs/testing/TEST_CASES_SERVICE.md)                      | Service layer tests (30 cases)           |
| [TEST_CASES_UI.md](specs/testing/TEST_CASES_UI.md)                                | UI, integration, performance, accessibility & edge case tests (55 cases) |

**Total: 126 test cases** (63 Must, 54 Should, 9 Could)

## License

MIT License
