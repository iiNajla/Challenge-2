
import Foundation
import Combine

final class ActivitiesCalendarViewModel: ObservableObject {

    // MARK: - Calendar Settings

    let calendar = Calendar(identifier: .gregorian)

    let year = 2026

    let months = [1, 2, 3]

    let weekdays = [
        "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"
    ]

    // MARK: - Today

    var today: Date {
        calendar.date(
            from: DateComponents(year: 2026, month: 3, day: 12)
        ) ?? Date()
    }

    // MARK: - Activity Data

    let learnedDays: [Int: Set<Int>] = [
        1: Set(1...11),
        2: Set(1...28).subtracting([20, 23]),
        3: [1, 2, 4, 5, 6, 9, 10, 11]
    ]

    let freezedDays: [Int: Set<Int>] = [
        2: [20, 23],
        3: [3, 7, 8]
    ]

    // MARK: - Calendar Logic

    func firstDate(of month: Int) -> Date {
        calendar.date(
            from: DateComponents(year: year, month: month, day: 1)
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

    // MARK: - Day Status

    func status(month: Int, day: Int) -> DayStatus {

        if learnedDays[month]?.contains(day) == true {
            return .learned
        }

        if freezedDays[month]?.contains(day) == true {
            return .freezed
        }

        return .none
    }

    // MARK: - Today Check

    func isToday(month: Int, day: Int) -> Bool {

        let parts = calendar.dateComponents(
            [.month, .day],
            from: today
        )

        return parts.month == month && parts.day == day
    }
}
