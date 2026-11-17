
import Foundation

enum DayStatus {
    case none
    case learned
    case freezed
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let letter: String
    let number: Int
    var status: DayStatus
}
