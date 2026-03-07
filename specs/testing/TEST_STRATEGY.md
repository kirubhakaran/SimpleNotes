# Test Strategy

## Overview

This document defines the testing approach for SimpleNotes. Tests are organized by architectural layer (Models, ViewModels, Services) and type (Unit, Integration, UI).

## Test Pyramid

```
          ┌───────────┐
          │  UI Tests  │   ~10%  (end-to-end workflows)
         ─┤           ├─
        / └───────────┘ \
       / ┌───────────────┐\
      /  │ Integration    │ \  ~20%  (cross-layer interactions)
     ─── │ Tests          │───
    /    └───────────────┘    \
   /   ┌───────────────────┐   \
  /    │   Unit Tests       │    \  ~70%  (models, VMs, services)
 ──────│                    │──────
       └───────────────────┘
```

## Test Types

| Type        | Scope                          | Framework       | Speed    |
|-------------|--------------------------------|-----------------|----------|
| Unit        | Single class or function       | XCTest + Swift Testing | Fast |
| Integration | Multiple layers together       | XCTest          | Medium   |
| UI          | Full app interaction flows     | XCUITest        | Slow     |
| Performance | Speed and memory benchmarks    | XCTest `measure` | Medium  |

## Test File Structure

```
Tests/
├── ModelTests/
│   ├── NoteModelTests.swift
│   ├── FolderModelTests.swift
│   └── TagModelTests.swift
├── ViewModelTests/
│   ├── SidebarViewModelTests.swift
│   └── NoteEditorViewModelTests.swift
├── ServiceTests/
│   ├── NoteServiceTests.swift
│   ├── SearchServiceTests.swift
│   └── ExportServiceTests.swift
├── IntegrationTests/
│   ├── NoteFolderIntegrationTests.swift
│   ├── SearchIntegrationTests.swift
│   └── ImportExportIntegrationTests.swift
├── UITests/
│   ├── NoteManagementUITests.swift
│   ├── FolderManagementUITests.swift
│   ├── SearchUITests.swift
│   ├── EditorUITests.swift
│   └── KeyboardShortcutUITests.swift
├── PerformanceTests/
│   ├── LaunchPerformanceTests.swift
│   ├── SearchPerformanceTests.swift
│   └── LargeDatasetTests.swift
└── Helpers/
    ├── TestModelContainer.swift    # In-memory Swift Data container
    ├── SampleData.swift            # Factory methods for test data
    └── XCTestCase+Extensions.swift # Common assertions
```

## Testing Conventions

### Naming
```
func test_<method>_<scenario>_<expectedResult>()
```
Example: `test_createNote_withDefaultValues_setsUntitledTitle()`

### Arrange-Act-Assert
Every test follows the AAA pattern:
```swift
func test_deleteNote_existingNote_removesFromContext() {
    // Arrange
    let note = SampleData.makeNote(title: "Test")

    // Act
    service.deleteNote(note, context: context)

    // Assert
    XCTAssertEqual(fetchNotes().count, 0)
}
```

### Test Data
- Use `TestModelContainer` for an **in-memory** Swift Data container (no disk I/O)
- Use `SampleData` factory methods to create consistent test objects
- Each test starts with a clean container (no shared state between tests)

## Coverage Targets

| Layer         | Target Coverage | Rationale                              |
|---------------|-----------------|----------------------------------------|
| Models        | 95%+            | Critical data integrity                |
| Services      | 90%+            | Core business logic                    |
| ViewModels    | 85%+            | State management and validation        |
| Views         | Via UI tests    | Covered by XCUITest flows              |

## CI Pipeline

```
git push
  │
  ▼
Build (xcodebuild) ─── Fail? → Block merge
  │
  ▼
Unit Tests ─── Fail? → Block merge
  │
  ▼
Integration Tests ─── Fail? → Block merge
  │
  ▼
UI Tests ─── Fail? → Warn (flaky tolerance)
  │
  ▼
Coverage Report → Enforce minimums
```

## Spec Compliance Testing

> **Every test must validate spec-defined behavior.** See `specs/SPEC_COMPLIANCE.md` for full rules.

### Traceability Requirement

Every test method must reference its spec source:

```swift
/// Spec: specs/behavior/CONTRACTS.md — NoteService.create
/// Spec: specs/behavior/STATE_MACHINE.md — ST-2: Post-Delete Selection
func test_create_defaultValues_returnsNoteWithDefaults() { ... }
```

### What Tests Must Verify

| Spec Document | Test Must Check |
|---------------|----------------|
| `CONTRACTS.md` | Method signatures, return values, error cases, behavior tables |
| `STATE_MACHINE.md` | State transitions, post-delete selection, preview mode persistence |
| `EDGE_CASES.md` | Boundary values, truncation rules, sort tiebreakers, threading |
| `LOCALIZATION.md` | All user-facing strings match spec keys exactly |
| `ACCESSIBILITY.md` | VoiceOver labels, hints, and roles present and correct |
| `DATA_MODEL.md` | Field types, defaults, relationship delete rules |

### Spec Compliance CI Gate

In addition to standard test gates, the CI pipeline must verify:

1. **Zero spec violations** — all test assertions validate spec-defined behavior
2. **Zero hardcoded strings** — all user-facing text uses `String(localized:)`
3. **Zero untraced tests** — every test method has a `/// Spec:` comment

---

## Test Documents

| Document                                              | Contents                            |
|-------------------------------------------------------|-------------------------------------|
| [TEST_CASES.md](TEST_CASES.md)                        | Model layer unit test cases         |
| [TEST_CASES_VIEWMODEL.md](TEST_CASES_VIEWMODEL.md)    | ViewModel layer test cases          |
| [TEST_CASES_SERVICE.md](TEST_CASES_SERVICE.md)        | Service layer test cases            |
| [TEST_CASES_UI.md](TEST_CASES_UI.md)                  | UI, integration, and performance tests |
