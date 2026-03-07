import SwiftUI

/// A single row in the note list showing title, preview, and relative date.
/// Reference: specs/UI_DESIGN.md — Note List (Column 2)
///            specs/accessibility/LOCALIZATION.md — Date Formatting Rules
struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Title row with optional pin icon
            HStack(spacing: 4) {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }

                Text(displayTitle)
                    .font(.headline)
                    .lineLimit(1)
            }

            // Body preview — first non-empty line
            Text(previewText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            // Relative date
            Text(note.modifiedAt.relativeFormatted)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }

    // MARK: - Computed

    /// Display title: use "Untitled Note" if title is empty.
    private var displayTitle: String {
        let trimmed = note.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
            ? String(localized: "Untitled Note")
            : note.title
    }

    /// Preview text: first non-empty line of the body, or empty string.
    private var previewText: String {
        let firstLine = note.body
            .components(separatedBy: .newlines)
            .first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty })
        return firstLine ?? ""
    }
}
