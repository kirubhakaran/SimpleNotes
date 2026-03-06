# Accessibility Specification

Ensures SimpleNotes is fully usable via VoiceOver, keyboard navigation, and Dynamic Type.

---

## Accessibility Standards

| Standard | Target |
|----------|--------|
| macOS Accessibility API | Full compliance |
| VoiceOver | All interactive elements labeled and navigable |
| Keyboard navigation | Full app usable without mouse |
| Dynamic Type | All text scales with system text size |
| Contrast ratio | Minimum 4.5:1 (WCAG AA) via semantic system colors |

---

## VoiceOver Labels

### Sidebar

| Element | Accessibility Label | Accessibility Hint | Role |
|---------|--------------------|--------------------|------|
| "All Notes" button | `"All Notes, {count} notes"` | `"Shows all notes"` | Button |
| Folder row | `"{folder name}, {count} notes"` | `"Shows notes in this folder"` | Button |
| Selected folder | `"{folder name}, selected, {count} notes"` | — | Button |
| "+ New Folder" button | `"New Folder"` | `"Creates a new folder"` | Button |

### Note List

| Element | Accessibility Label | Accessibility Hint | Role |
|---------|--------------------|--------------------|------|
| Search bar | `"Search notes"` | `"Filters notes by title and content"` | Search Field |
| Note row (unpinned) | `"{title}, {preview}, {relative date}"` | `"Opens note in editor"` | Button |
| Note row (pinned) | `"Pinned, {title}, {preview}, {relative date}"` | `"Opens note in editor"` | Button |
| Note row (selected) | `"{title}, selected"` | — | Button |
| Empty state | `"No notes. Press Command N to create your first note."` | — | Static Text |
| Search empty state | `"No results for {query}"` | — | Static Text |

### Editor

| Element | Accessibility Label | Accessibility Hint | Role |
|---------|--------------------|--------------------|------|
| Title field | `"Note title"` | `"Edit the note title"` | Text Field |
| Body field | `"Note body"` | `"Edit the note content"` | Text Editor |
| Edit button | `"Edit mode"` | `"Switch to text editing"` | Toggle |
| Preview button | `"Preview mode"` | `"Switch to Markdown preview"` | Toggle |
| Word count | `"{count} words"` | — | Static Text |
| Character count | `"{count} characters"` | — | Static Text |
| Preview content | `"Markdown preview"` | `"Read-only rendered view"` | Group |

### Confirmation Dialogs

| Element | Accessibility Label | Role |
|---------|---------------------|------|
| Delete Note dialog | `"Delete note confirmation"` | Alert |
| Delete Folder dialog | `"Delete folder confirmation"` | Alert |
| Cancel button | `"Cancel"` | Button |
| Delete button | `"Delete"` | Destructive Button |

### Context Menus

| Element | Accessibility Label | Role |
|---------|---------------------|------|
| Pin action | `"Pin note"` / `"Unpin note"` | Menu Item |
| Duplicate action | `"Duplicate note"` | Menu Item |
| Move to folder | `"Move to folder"` | Menu Item (submenu) |
| Delete action | `"Delete note"` | Destructive Menu Item |
| Rename folder | `"Rename folder"` | Menu Item |
| Delete folder | `"Delete folder"` | Destructive Menu Item |

---

## Keyboard Navigation (Focus Order)

### Tab Order (Forward: Tab, Backward: Shift+Tab)

```
1. Sidebar
   ├── "All Notes" button
   ├── Folder 1
   ├── Folder 2
   ├── ...
   └── "+ New Folder" button

2. Note List
   ├── Search bar
   ├── Note row 1
   ├── Note row 2
   └── ...

3. Editor
   ├── Title field
   ├── Body field
   └── Edit/Preview toggle
```

### Arrow Key Navigation

| Context | Arrow Key | Behavior |
|---------|-----------|----------|
| Sidebar focused | Up/Down | Move between folders |
| Note list focused | Up/Down | Move between notes |
| Editor body focused | Up/Down/Left/Right | Standard text navigation |
| Search bar focused | Down | Move focus to first note row |

### Escape Key

| Context | Behavior |
|---------|----------|
| Search bar focused | Clear search, move focus to editor |
| Context menu open | Close menu |
| Dialog open | Cancel / dismiss dialog |
| Folder rename active | Cancel rename, restore original name |

---

## Dynamic Type Support

### Scaling Rules

| Element | Base Size | Scales With | Min Size | Max Size |
|---------|-----------|-------------|----------|----------|
| Sidebar folder name | 13pt | System text size | 11pt | 24pt |
| Note row title | 13pt | System text size | 11pt | 24pt |
| Note row preview | 11pt | System text size | 9pt | 20pt |
| Note row date | 10pt | System text size | 8pt | 18pt |
| Editor title | 22pt | System text size | 18pt | 40pt |
| Editor body | 14pt | System text size | 12pt | 28pt |
| Word/char count | 10pt | System text size | 8pt | 18pt |

### Layout Adaptation

| Text Size | Layout Change |
|-----------|---------------|
| Default - Large | No changes |
| Extra Large | Note row height increases to fit larger text |
| XXL - XXXL | Note list preview text may truncate to 1 line instead of 2 |
| Accessibility sizes | Sidebar icons scale, column min-widths increase |

---

## Reduced Motion

| Animation | Default | Reduced Motion |
|-----------|---------|----------------|
| Note selection highlight | Animated (200ms fade) | Instant (no animation) |
| Folder expand/collapse | Animated (250ms slide) | Instant |
| Preview mode toggle | Animated (200ms crossfade) | Instant swap |
| Note list reorder (pin/unpin) | Animated (300ms move) | Instant reorder |
| Delete note from list | Animated (250ms slide-out) | Instant removal |

Check `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion` and use `.animation(reduceMotion ? .none : .default)`.

---

## High Contrast Mode

| Element | Standard | High Contrast |
|---------|----------|---------------|
| Selected note row | Accent color at 10%/20% opacity | Solid accent color border (2pt) |
| Folder separator | 1pt gray line | 2pt high-contrast line |
| Editor title/body border | None (borderless) | 1pt border visible |
| Buttons | Standard macOS style | Outlined with visible border |

Uses `NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast` to adapt.

---

## Accessibility Testing Checklist

| Test | How to Verify |
|------|---------------|
| VoiceOver reads all note rows | Enable VO, arrow through note list |
| VoiceOver reads folder count | Enable VO, navigate to folder row |
| VoiceOver announces edit/preview toggle | Enable VO, press Cmd+Shift+P |
| Tab order follows spec above | Press Tab repeatedly through all elements |
| Escape clears search | Focus search, type text, press Escape |
| Dynamic Type scales correctly | Change System Settings > Accessibility > Display > Text Size |
| Reduced Motion removes animations | Enable Reduce Motion in Accessibility settings |
| High Contrast adds borders | Enable Increase Contrast in Accessibility settings |
| Minimum touch target (keyboard focus) | All focusable elements ≥ 24x24pt |
| Screen reader announces delete confirmation | Enable VO, delete a note, verify dialog is read |
