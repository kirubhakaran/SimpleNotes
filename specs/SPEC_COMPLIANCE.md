# Spec Compliance — Mandatory Rules

This document defines **mandatory governance rules** ensuring that spec and code remain in perfect alignment. These rules apply to all contributors — human and AI.

---

## 1. Spec-First Rule

> **Specs are the single source of truth.** If spec and code disagree, the spec wins.

All code must be generated from, and traceable back to, the specification documents. No behavior, string, constant, or state transition may exist in code without a corresponding spec entry.

| Principle | Rule |
|-----------|------|
| Source of truth | Spec files in `specs/` directory |
| Code authority | Code implements specs; it does not define behavior |
| Conflict resolution | Spec wins — update code to match spec |
| New behavior | Write the spec first, then implement |

---

## 2. Deterministic Generation Rule

> The specs must be precise enough that **any AI tool** (Claude Code, OpenAI Codex, Cursor, Copilot, or a new developer) generates **functionally identical code** from the same specs.

This means every spec entry must be **unambiguous**:

| What Must Be Specified | Example |
|------------------------|---------|
| Method signatures | `func create(in folder: Folder? = nil, context: ModelContext) throws -> Note` |
| Default values | Title default = `"Untitled Note"` |
| Error types | `SimpleNotesError.saveFailed(underlying: Error)` |
| User-facing strings | Exact text: `"Press ⌘N to create your first note."` |
| Sort orders with tiebreakers | `isPinned desc → modifiedAt desc → createdAt desc → id asc` |
| State transitions | `Create note → selectedNote = new note, isPreviewMode = false, searchQuery = ""` |
| Validation rules | Title > 500 chars → silently truncate |
| Configuration constants | `DEBOUNCE_INTERVAL = 300ms` |
| Accessibility labels | Title field label = `"Note title"`, hint = `"Edit the note title"` |

If a spec is ambiguous or incomplete, it **must be updated before coding**.

---

## 3. Mandatory Check-in Verification

> **Before every commit**, the following 10-point checklist must pass. No exceptions.

### Check-in Checklist

| # | Check | Spec Reference |
|---|-------|---------------|
| 1 | All method signatures in code match spec exactly | `specs/behavior/CONTRACTS.md` |
| 2 | All user-facing strings in code match spec exactly | `specs/accessibility/LOCALIZATION.md` |
| 3 | All state transitions in code match spec exactly | `specs/behavior/STATE_MACHINE.md` |
| 4 | All constants in code match spec values | `specs/behavior/EDGE_CASES.md` |
| 5 | All sort orders in code include full tiebreaker chain | `specs/behavior/EDGE_CASES.md` |
| 6 | All accessibility labels in code match spec | `specs/accessibility/ACCESSIBILITY.md` |
| 7 | All validation rules in code match spec | `specs/behavior/EDGE_CASES.md` |
| 8 | All error types and messages in code match spec | `specs/behavior/CONTRACTS.md` + `specs/accessibility/LOCALIZATION.md` |
| 9 | Build succeeds with **zero warnings** | `xcodebuild` |
| 10 | All existing tests pass | `xcodebuild test` |

### Verification Process

```
1. Run: xcodebuild -scheme SimpleNotes build  (must pass, zero warnings)
2. Run: xcodebuild -scheme SimpleNotes test   (must pass, all green)
3. Audit: grep all String(localized:) calls → verify each against LOCALIZATION.md
4. Audit: verify constants match EDGE_CASES.md values
5. Audit: verify method signatures match CONTRACTS.md
6. Commit only after all 10 checks pass
```

---

## 4. Spec Update Protocol

> **Never commit code that contradicts any spec file.**

When implementation requires a deviation from spec:

```
Step 1: Update the spec document FIRST
Step 2: Update all cross-references (test cases, contracts, state machine, etc.)
Step 3: Run the cross-reference consistency audit
Step 4: Then update the code
Step 5: Verify check-in checklist (Section 3)
Step 6: Commit spec changes and code changes together (atomic commit)
```

### Cross-Reference Map

When updating a spec, check these dependent documents:

| If you change... | Also update... |
|-----------------|----------------|
| `CONTRACTS.md` | `TEST_CASES_SERVICE.md`, `TEST_CASES_VIEWMODEL.md`, `EDGE_CASES.md` |
| `STATE_MACHINE.md` | `TEST_CASES_VIEWMODEL.md`, `TEST_CASES_UI.md` |
| `EDGE_CASES.md` | `CONTRACTS.md`, `TEST_CASES*.md`, `LOCALIZATION.md` |
| `DATA_MODEL.md` | `CONTRACTS.md`, `TEST_CASES.md` |
| `LOCALIZATION.md` | Code: all `String(localized:)` calls |
| `ACCESSIBILITY.md` | Code: all `.accessibilityLabel()` / `.accessibilityHint()` calls |
| `UI_DESIGN.md` | Code: view files, `TEST_CASES_UI.md` |
| `REQUIREMENTS.md` | `ROADMAP.md`, `TEST_CASES*.md` |

---

## 5. Code Traceability

> Every code file must reference the spec it implements.

### File-Level Reference

Every Swift file must include a doc comment referencing its primary spec:

```swift
/// Note CRUD operations.
/// Reference: specs/behavior/CONTRACTS.md — NoteService
struct NoteService { ... }
```

### Method-Level Reference

Critical methods should reference specific spec sections:

```swift
/// Reference: specs/behavior/STATE_MACHINE.md — ST-2: Post-Delete Selection
private func applyPostDeleteSelection(...) { ... }
```

### String-Level Reference

User-facing strings should reference their localization key:

```swift
/// Reference: specs/accessibility/LOCALIZATION.md — empty.noNotesHint
Text(String(localized: "Press ⌘N to create your first note."))
```

---

## 6. Spec Completeness Test

Before starting any new phase of development, verify the spec is complete:

| Question | Must Have Answer |
|----------|-----------------|
| What methods exist? | Exact signatures in `CONTRACTS.md` |
| What happens on each action? | State transitions in `STATE_MACHINE.md` |
| What are the boundaries? | Validation rules in `EDGE_CASES.md` |
| What does the user see? | Layout in `UI_DESIGN.md`, strings in `LOCALIZATION.md` |
| What does VoiceOver say? | Labels in `ACCESSIBILITY.md` |
| How is it tested? | Test cases in `TEST_CASES*.md` |

If any question lacks a clear answer, **write the spec before writing code**.
