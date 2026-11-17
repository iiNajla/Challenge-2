
import SwiftUI
import Combine

final class ActivityTask3ViewModel: ObservableObject {

    // MARK: - Goal Data

    @Published var topic: String
    @Published var timeframe: Timeframe

    // MARK: - Activity Data

    @Published var days: [CalendarDay] = [
        CalendarDay(letter: "S", number: 20, status: .learned),
        CalendarDay(letter: "M", number: 21, status: .learned),
        CalendarDay(letter: "T", number: 22, status: .none),
        CalendarDay(letter: "W", number: 23, status: .freezed),
        CalendarDay(letter: "T", number: 24, status: .none),
        CalendarDay(letter: "F", number: 25, status: .none),
        CalendarDay(letter: "S", number: 26, status: .none)
    ]

    @Published var goalState: GoalState = .inProgress

    // MARK: - Constants

    let todayIndex = 4
    let maxFreezes = 2
    let goalDays = 3

    // MARK: - Initializer

    init(topic: String = "", timeframe: Timeframe = .week) {
        self.topic = topic
        self.timeframe = timeframe
    }

    // MARK: - Computed Properties

    var todayStatus: DayStatus {
        days[todayIndex].status
    }

    var learnedCount: Int {
        days.filter { $0.status == .learned }.count
    }

    var freezedCount: Int {
        days.filter { $0.status == .freezed }.count
    }

    var canFreeze: Bool {
        todayStatus == .none && freezedCount < maxFreezes
    }

    // MARK: - Actions

    func logAsLearned() {
        guard todayStatus != .learned else { return }

        days[todayIndex].status = .learned
        updateGoalState()
    }

    func freezeDay() {
        guard canFreeze else { return }

        days[todayIndex].status = .freezed
        updateGoalState()
    }

    func updateGoal(newTopic: String, newTimeframe: Timeframe) {
        topic = newTopic
        timeframe = newTimeframe
        resetGoal()
    }

    // MARK: - Goal Logic

    private func updateGoalState() {
        if learnedCount >= goalDays {
            goalState = .completed
        } else if todayStatus == .freezed && freezedCount >= maxFreezes {
            goalState = .notMet
        }
    }

    func resetGoal() {
        days = [
            CalendarDay(letter: "S", number: 20, status: .learned),
            CalendarDay(letter: "M", number: 21, status: .learned),
            CalendarDay(letter: "T", number: 22, status: .none),
            CalendarDay(letter: "W", number: 23, status: .freezed),
            CalendarDay(letter: "T", number: 24, status: .none),
            CalendarDay(letter: "F", number: 25, status: .none),
            CalendarDay(letter: "S", number: 26, status: .none)
        ]

        goalState = .inProgress
    }
}
