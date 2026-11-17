
import Foundation

enum DayStatus: String, Codable {
    case none
    case learned
    case freezed
}

struct CalendarDay: Identifiable, Codable {
    let id: UUID
    let letter: String
    let number: Int
    var status: DayStatus

    init(
        id: UUID = UUID(),
        letter: String,
        number: Int,
        status: DayStatus
    ) {
        self.id = id
        self.letter = letter
        self.number = number
        self.status = status
    }
}
