# Data Model

## Overview

All data is stored locally using **Swift Data** with automatic persistence. No network or cloud sync.

## Entity Relationship Diagram

```
┌─────────────────────┐       ┌─────────────────────┐
│       Folder         │       │        Tag           │
├─────────────────────┤       ├─────────────────────┤
│ id: UUID (PK)       │       │ id: UUID (PK)       │
│ name: String         │       │ name: String         │
│ displayOrder: Int    │       │ color: String?       │
│ createdAt: Date      │       │ createdAt: Date      │
└────────┬────────────┘       └──────────┬──────────┘
         │ 1                              │ M
         │                                │
         │ M                              │ M
┌────────┴────────────────────────────────┴──────────┐
│                       Note                         │
├────────────────────────────────────────────────────┤
│ id: UUID (PK)                                      │
│ title: String                                      │
│ body: String                                       │
│ isPinned: Bool                                     │
│ createdAt: Date                                    │
│ modifiedAt: Date                                   │
│ folder: Folder? (FK)                               │
│ tags: [Tag]                                        │
└────────────────────────────────────────────────────┘
```

## Model Definitions

### Note

| Field       | Type       | Default            | Description                        |
|-------------|------------|--------------------|------------------------------------|
| `id`        | `UUID`     | `UUID()`           | Unique identifier                  |
| `title`     | `String`   | `"Untitled Note"`  | Note title                         |
| `body`      | `String`   | `""`               | Note content (plain text/Markdown) |
| `isPinned`  | `Bool`     | `false`            | Whether note is pinned to top      |
| `createdAt` | `Date`     | `Date.now`         | Creation timestamp                 |
| `modifiedAt`| `Date`     | `Date.now`         | Last modification timestamp        |
| `folder`    | `Folder?`  | `nil`              | Parent folder (optional)           |
| `tags`      | `[Tag]`    | `[]`               | Associated tags (many-to-many)     |

### Folder

| Field          | Type     | Default       | Description                    |
|----------------|----------|---------------|--------------------------------|
| `id`           | `UUID`   | `UUID()`      | Unique identifier              |
| `name`         | `String` | `"New Folder"`| Folder display name            |
| `displayOrder` | `Int`    | `0`           | Sort position in sidebar       |
| `createdAt`    | `Date`   | `Date.now`    | Creation timestamp             |
| `notes`        | `[Note]` | `[]`          | Child notes (inverse relation) |

### Tag

| Field       | Type     | Default       | Description                    |
|-------------|----------|---------------|--------------------------------|
| `id`        | `UUID`   | `UUID()`      | Unique identifier              |
| `name`      | `String` | `""`          | Tag label                      |
| `color`     | `String?`| `nil`         | Optional hex color string      |
| `createdAt` | `Date`   | `Date.now`    | Creation timestamp             |
| `notes`     | `[Note]` | `[]`          | Tagged notes (inverse relation)|

## Relationships

| Relationship      | Type          | Cascade Delete              |
|--------------------|---------------|-----------------------------|
| Folder → Notes     | One-to-Many   | Notes set `folder = nil`    |
| Note → Folder      | Many-to-One   | No cascade                  |
| Note ↔ Tags        | Many-to-Many  | Remove association only     |

**Delete behavior**: Deleting a folder does **not** delete its notes; they become unfiled. Deleting a tag removes the association but keeps the notes.

## Indexes

| Index                    | Purpose                                  |
|--------------------------|------------------------------------------|
| `Note.modifiedAt`        | Sort notes by recently modified          |
| `Note.title`             | Full-text search on titles               |
| `Note.body`              | Full-text search on content              |
| `Note.isPinned`          | Quick filter for pinned notes            |
| `Folder.displayOrder`    | Sidebar ordering                         |

## Storage Location

```
~/Library/Containers/com.simplenotes.app/Data/Library/Application Support/
└── default.store          # Swift Data SQLite database
```

## Data Constraints

| Constraint                     | Value                     |
|--------------------------------|---------------------------|
| Max title length               | 500 characters            |
| Max body length                | No hard limit             |
| Max folder name length         | 100 characters            |
| Max tag name length            | 50 characters             |
| Max tags per note              | 20                        |
| Max folders                    | No hard limit             |
