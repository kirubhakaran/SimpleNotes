# Test Cases: Models

Unit tests for the Swift Data model layer (`Note`, `Folder`, `Tag`).

---

## TC-M1: Note Model

### TC-M1.1: Note Creation - Default Values

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.1                                               |
| **Requirement**| FR-1.1                                                |
| **Description**| Creating a Note with no arguments uses correct defaults |
| **Precondition** | In-memory ModelContainer initialized                |
| **Steps**      | 1. Create `Note()` with no arguments                  |
|                | 2. Insert into context                                |
| **Expected**   | `title == "Untitled Note"`, `body == ""`, `isPinned == false`, `folder == nil`, `tags == []`, `createdAt` and `modifiedAt` are set to current time |
| **Priority**   | Must                                                  |

### TC-M1.2: Note Creation - Custom Values

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.2                                               |
| **Requirement**| FR-1.1                                                |
| **Description**| Creating a Note with custom arguments stores them correctly |
| **Precondition** | In-memory ModelContainer initialized                |
| **Steps**      | 1. Create `Note(title: "My Note", body: "Hello")` |
|                | 2. Insert into context                                |
| **Expected**   | `title == "My Note"`, `body == "Hello"`               |
| **Priority**   | Must                                                  |

### TC-M1.3: Note - Unique ID Generation

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.3                                               |
| **Requirement**| DATA_MODEL                                            |
| **Description**| Each new Note receives a unique UUID                  |
| **Steps**      | 1. Create two `Note()` instances                      |
| **Expected**   | `note1.id != note2.id`                                |
| **Priority**   | Must                                                  |

### TC-M1.4: Note - Title Max Length

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.4                                               |
| **Requirement**| DATA_MODEL (500 char limit)                           |
| **Description**| Note title respects 500 character maximum             |
| **Steps**      | 1. Create Note with title of 501 characters           |
|                | 2. Attempt to save                                    |
| **Expected**   | Title is truncated to 500 characters or validation error raised |
| **Priority**   | Should                                                |

### TC-M1.5: Note - modifiedAt Updates on Edit

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.5                                               |
| **Requirement**| FR-1.6                                                |
| **Description**| Editing a note's body updates `modifiedAt` timestamp  |
| **Steps**      | 1. Create note, record `modifiedAt`                   |
|                | 2. Wait briefly, then update `body`                   |
|                | 3. Save context                                       |
| **Expected**   | `modifiedAt` is later than original timestamp         |
| **Priority**   | Must                                                  |

### TC-M1.6: Note - modifiedAt Updates on Title Edit

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.6                                               |
| **Requirement**| FR-1.6                                                |
| **Description**| Editing a note's title updates `modifiedAt` timestamp |
| **Steps**      | 1. Create note, record `modifiedAt`                   |
|                | 2. Update `title`                                     |
| **Expected**   | `modifiedAt` is later than original timestamp         |
| **Priority**   | Must                                                  |

### TC-M1.7: Note - Pin State Toggle

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.7                                               |
| **Requirement**| FR-1.5                                                |
| **Description**| Toggling `isPinned` persists correctly                |
| **Steps**      | 1. Create note (`isPinned == false`)                  |
|                | 2. Set `isPinned = true`, save                        |
|                | 3. Fetch note from context                            |
| **Expected**   | Fetched note has `isPinned == true`                   |
| **Priority**   | Should                                                |

### TC-M1.8: Note - Empty Body Allowed

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.8                                               |
| **Requirement**| FR-4.1                                                |
| **Description**| A note with an empty body is valid and persists       |
| **Steps**      | 1. Create `Note(title: "Empty", body: "")`            |
|                | 2. Save and fetch                                     |
| **Expected**   | Note exists with `body == ""`                         |
| **Priority**   | Must                                                  |

### TC-M1.9: Note - Large Body Content

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M1.9                                               |
| **Requirement**| DATA_MODEL (no hard limit on body)                    |
| **Description**| A note with a very large body (100KB+) persists       |
| **Steps**      | 1. Create note with body of 100,000 characters        |
|                | 2. Save and fetch                                     |
| **Expected**   | Note persists and body content is intact              |
| **Priority**   | Should                                                |

---

## TC-M2: Folder Model

### TC-M2.1: Folder Creation - Default Values

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M2.1                                               |
| **Requirement**| FR-2.2                                                |
| **Description**| Creating a Folder with no arguments uses defaults     |
| **Steps**      | 1. Create `Folder()` with no arguments                |
| **Expected**   | `name == "New Folder"`, `displayOrder == 0`, `notes == []`, `createdAt` is set |
| **Priority**   | Must                                                  |

### TC-M2.2: Folder Creation - Custom Name

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M2.2                                               |
| **Requirement**| FR-2.2                                                |
| **Description**| Creating a Folder with a custom name stores it        |
| **Steps**      | 1. Create `Folder(name: "Work")`                      |
| **Expected**   | `name == "Work"`                                      |
| **Priority**   | Must                                                  |

### TC-M2.3: Folder - Name Max Length

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M2.3                                               |
| **Requirement**| DATA_MODEL (100 char limit)                           |
| **Description**| Folder name respects 100 character maximum            |
| **Steps**      | 1. Create Folder with 101-character name              |
| **Expected**   | Name truncated to 100 characters or validation error  |
| **Priority**   | Should                                                |

### TC-M2.4: Folder - Display Order Sorting

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M2.4                                               |
| **Requirement**| UI_DESIGN (sidebar ordering)                          |
| **Description**| Folders sort correctly by `displayOrder`              |
| **Steps**      | 1. Create folders with `displayOrder` 2, 0, 1         |
|                | 2. Fetch with sort descriptor on `displayOrder`       |
| **Expected**   | Returned in order: 0, 1, 2                            |
| **Priority**   | Must                                                  |

### TC-M2.5: Folder - Unique ID Generation

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M2.5                                               |
| **Requirement**| DATA_MODEL                                            |
| **Description**| Each Folder receives a unique UUID                    |
| **Steps**      | 1. Create two `Folder()` instances                    |
| **Expected**   | `folder1.id != folder2.id`                            |
| **Priority**   | Must                                                  |

---

## TC-M3: Tag Model

### TC-M3.1: Tag Creation - Default Values

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M3.1                                               |
| **Requirement**| FR-2.4                                                |
| **Description**| Creating a Tag with no arguments uses defaults        |
| **Steps**      | 1. Create `Tag()` with no arguments                   |
| **Expected**   | `name == ""`, `color == nil`, `notes == []`           |
| **Priority**   | Could                                                 |

### TC-M3.2: Tag - Custom Name and Color

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M3.2                                               |
| **Requirement**| FR-2.4                                                |
| **Description**| Tag stores custom name and optional color             |
| **Steps**      | 1. Create `Tag(name: "Urgent", color: "#FF0000")`     |
| **Expected**   | `name == "Urgent"`, `color == "#FF0000"`              |
| **Priority**   | Could                                                 |

### TC-M3.3: Tag - Name Max Length

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M3.3                                               |
| **Requirement**| DATA_MODEL (50 char limit)                            |
| **Description**| Tag name respects 50 character maximum                |
| **Steps**      | 1. Create Tag with 51-character name                  |
| **Expected**   | Name truncated to 50 characters or validation error   |
| **Priority**   | Could                                                 |

---

## TC-M4: Relationships

### TC-M4.1: Note-Folder - Assign Note to Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.1                                               |
| **Requirement**| FR-2.1                                                |
| **Description**| Assigning a note to a folder creates the relationship |
| **Steps**      | 1. Create a Folder and a Note                         |
|                | 2. Set `note.folder = folder`                         |
|                | 3. Save context                                       |
| **Expected**   | `note.folder == folder`, `folder.notes.contains(note)` |
| **Priority**   | Must                                                  |

### TC-M4.2: Note-Folder - Note Without Folder

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.2                                               |
| **Requirement**| FR-2.1                                                |
| **Description**| A note can exist without a folder (unfiled)           |
| **Steps**      | 1. Create a Note without setting folder               |
| **Expected**   | `note.folder == nil`, note is fetchable               |
| **Priority**   | Must                                                  |

### TC-M4.3: Note-Folder - Move Note Between Folders

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.3                                               |
| **Requirement**| FR-2.3                                                |
| **Description**| Changing a note's folder updates both sides           |
| **Steps**      | 1. Create Folder A, Folder B, and a Note in Folder A  |
|                | 2. Set `note.folder = folderB`                        |
|                | 3. Save context                                       |
| **Expected**   | `folderA.notes` does not contain note, `folderB.notes` contains note |
| **Priority**   | Should                                                |

### TC-M4.4: Note-Folder - Delete Folder Unfiles Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.4                                               |
| **Requirement**| DATA_MODEL (cascade behavior)                         |
| **Description**| Deleting a folder sets its notes' folder to nil       |
| **Steps**      | 1. Create Folder with 3 notes                         |
|                | 2. Delete the folder                                  |
|                | 3. Save and fetch notes                               |
| **Expected**   | All 3 notes still exist with `folder == nil`          |
| **Priority**   | Must                                                  |

### TC-M4.5: Note-Tag - Add Tags to Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.5                                               |
| **Requirement**| FR-2.4                                                |
| **Description**| Adding tags to a note creates many-to-many relationship |
| **Steps**      | 1. Create a Note and two Tags                         |
|                | 2. Append both tags to `note.tags`                    |
|                | 3. Save context                                       |
| **Expected**   | `note.tags.count == 2`, each tag's `notes` contains the note |
| **Priority**   | Could                                                 |

### TC-M4.6: Note-Tag - Max Tags Per Note

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.6                                               |
| **Requirement**| DATA_MODEL (max 20 tags)                              |
| **Description**| A note cannot have more than 20 tags                  |
| **Steps**      | 1. Create a Note and 21 Tags                          |
|                | 2. Attempt to assign all 21 to the note               |
| **Expected**   | Only 20 tags allowed; 21st is rejected or error raised |
| **Priority**   | Could                                                 |

### TC-M4.7: Note-Tag - Delete Tag Removes Association

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.7                                               |
| **Requirement**| DATA_MODEL (cascade behavior)                         |
| **Description**| Deleting a tag removes association but keeps the note |
| **Steps**      | 1. Create Note with 2 tags                            |
|                | 2. Delete one tag                                     |
|                | 3. Fetch note                                         |
| **Expected**   | Note still exists, `note.tags.count == 1`             |
| **Priority**   | Could                                                 |

### TC-M4.8: Note-Tag - Same Tag on Multiple Notes

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.8                                               |
| **Requirement**| FR-2.4                                                |
| **Description**| A single tag can be shared across multiple notes      |
| **Steps**      | 1. Create 3 Notes and 1 Tag                           |
|                | 2. Add the tag to all 3 notes                         |
| **Expected**   | `tag.notes.count == 3`                                |
| **Priority**   | Could                                                 |

### TC-M4.9: Folder - Multiple Notes Association

| Field          | Detail                                                |
|----------------|-------------------------------------------------------|
| **ID**         | TC-M4.9                                               |
| **Requirement**| FR-2.1                                                |
| **Description**| A folder can contain many notes                       |
| **Steps**      | 1. Create a Folder and 5 Notes                        |
|                | 2. Assign all notes to the folder                     |
| **Expected**   | `folder.notes.count == 5`                             |
| **Priority**   | Must                                                  |
