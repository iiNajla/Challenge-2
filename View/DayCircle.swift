
import SwiftUI

struct DayCircle: View {

    let day: CalendarDay
    let isToday: Bool

    private var background: Color {
        switch day.status {
        case .learned:
            return Color.appOrange.opacity(0.2)
        case .freezed:
            return Color.appBlue.opacity(0.2)
        case .none:
            return isToday ? Color.appOrange : Color.clear
        }
    }

    private var textColor: Color {
        switch day.status {
        case .learned:
            return Color.appOrange
        case .freezed:
            return Color.appBlue
        case .none:
            return Color.white
        }
    }

    var body: some View {
        Text("\(day.number)")
            .font(.title3.weight(.semibold))
            .foregroundStyle(textColor)
            .frame(width: 40, height: 40)
            .background(background, in: Circle())
    }
}
