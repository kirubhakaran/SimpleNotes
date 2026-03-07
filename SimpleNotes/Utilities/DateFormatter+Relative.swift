import Foundation

/// Relative date formatting for note row display.
/// Reference: specs/accessibility/LOCALIZATION.md — Date Formatting Rules
extension Date {
    /// Formats a date relative to now:
    /// - Today: "2:30 PM"
    /// - Yesterday: "Yesterday"
    /// - This week: day name ("Monday")
    /// - This year: "Mar 3"
    /// - Older: "Mar 3, 2024"
    var relativeFormatted: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return self.formatted(date: .omitted, time: .shortened)
        }

        if calendar.isDateInYesterday(self) {
            return String(localized: "Yesterday")
        }

        if let daysAgo = calendar.dateComponents([.day], from: self, to: .now).day,
           daysAgo >= 0, daysAgo < 7 {
            return self.formatted(.dateTime.weekday(.wide))
        }

        if calendar.component(.year, from: self) == calendar.component(.year, from: .now) {
            return self.formatted(.dateTime.month(.abbreviated).day())
        }

        return self.formatted(date: .abbreviated, time: .omitted)
    }
}
