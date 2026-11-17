
import Foundation
import Combine

final class ActivitiesCalendarViewModel: ObservableObject {

    // MARK: - Calendar Settings

    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }()

    private let activityStorageKey = "savedActivities"

    var year: Int {
        calendar.component(.year, from: Date())
    }

    var months: [Int] {
        let currentMonth = calendar.component(.month, from: Date())
        return Array(max(1, currentMonth - 2)...currentMonth)
    }

    let weekdays = [
        "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"
    ]

    // MARK: - Today

    var today: Date {
        calendar.startOfDay(for: Date())
    }

    // MARK: - Calendar Logic

    func firstDate(of month: Int) -> Date {
        calendar.date(
            from: DateComponents(
                year: year,
                month: month,
                day: 1
            )
        ) ?? Date()
    }

    func weekdayOffset(for month: Int) -> Int {
        let first = firstDate(of: month)
        return calendar.component(.weekday, from: first) - 1
    }

    func dayCount(for month: Int) -> Int {
        let first = firstDate(of: month)

        return calendar.range(
            of: .day,
            in: .month,
            for: first
        )?.count ?? 30
    }

    // MARK: - Saved Activity Status

    func status(month: Int, day: Int) -> DayStatus {

        guard let date = calendar.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day
            )
        ) else {
            return .none
        }

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        let key = formatter.string(from: date)

        let savedActivities = UserDefaults.standard.dictionary(
            forKey: activityStorageKey
        ) as? [String: String] ?? [:]

        return savedActivities[key].flatMap {
            DayStatus(rawValue: $0)
        } ?? .none
    }

    // MARK: - Today Check

    func isToday(month: Int, day: Int) -> Bool {

        let parts = calendar.dateComponents(
            [.year, .month, .day],
            from: today
        )

        return parts.year == year &&
               parts.month == month &&
               parts.day == day
    }

    // MARK: - Refresh Calendar

    func refreshCalendar() {
        objectWillChange.send()
    }
}
