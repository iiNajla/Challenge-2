
import SwiftUI
import Combine

final class ActivityTask3ViewModel: ObservableObject {

    // MARK: - Calendar

    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }()

    private let activityStorageKey = "savedActivities"
    private let topicStorageKey = "savedTopic"
    private let timeframeStorageKey = "savedTimeframe"
    private let goalStateStorageKey = "savedGoalState"

    // MARK: - Goal Data

    @Published var topic: String
    @Published var timeframe: Timeframe
    @Published var goalState: GoalState = .inProgress

    // MARK: - Activity Data

    @Published var days: [CalendarDay] = []

    // MARK: - Constants

    let maxFreezes = 2
    let goalDays = 3

    var todayIndex: Int {
        calendar.component(.weekday, from: Date()) - 1
    }

    // MARK: - Initializer

    init(topic: String = "", timeframe: Timeframe = .week) {

        let savedTopic = UserDefaults.standard.string(
            forKey: topicStorageKey
        )

        let savedTimeframe = UserDefaults.standard.string(
            forKey: timeframeStorageKey
        )

        self.topic = savedTopic ?? topic

        self.timeframe = savedTimeframe.flatMap {
            Timeframe(rawValue: $0)
        } ?? timeframe

        self.goalState = UserDefaults.standard.string(
            forKey: goalStateStorageKey
        ).flatMap {
            GoalState(rawValue: $0)
        } ?? .inProgress

        refreshWeek()
    }

    // MARK: - Computed Properties

    var todayStatus: DayStatus {
        guard days.indices.contains(todayIndex) else {
            return .none
        }

        return days[todayIndex].status
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

    var canUndo: Bool {
        todayStatus != .none
    }

    // MARK: - Date Storage

    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: date)
    }

    private func saveTodayStatus() {

        let today = calendar.startOfDay(for: Date())
        let key = dateKey(for: today)

        var savedActivities = UserDefaults.standard.dictionary(
            forKey: activityStorageKey
        ) as? [String: String] ?? [:]

        savedActivities[key] = todayStatus.rawValue

        UserDefaults.standard.set(
            savedActivities,
            forKey: activityStorageKey
        )
    }

    // MARK: - Calendar Actions

    func refreshWeek() {

        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)

        guard let firstDay = calendar.date(
            byAdding: .day,
            value: -(weekday - 1),
            to: today
        ) else { return }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEEE"

        let savedActivities = UserDefaults.standard.dictionary(
            forKey: activityStorageKey
        ) as? [String: String] ?? [:]

        days = (0..<7).compactMap { offset in

            guard let date = calendar.date(
                byAdding: .day,
                value: offset,
                to: firstDay
            ) else { return nil }

            let key = dateKey(for: date)

            let status = savedActivities[key].flatMap {
                DayStatus(rawValue: $0)
            } ?? .none

            return CalendarDay(
                letter: formatter.string(from: date),
                number: calendar.component(.day, from: date),
                status: status
            )
        }
    }

    // MARK: - Activity Actions

    func logAsLearned() {

        guard todayStatus == .none else { return }

        days[todayIndex].status = .learned

        saveTodayStatus()
        updateGoalState()
    }

    func freezeDay() {

        guard canFreeze else { return }

        days[todayIndex].status = .freezed

        saveTodayStatus()
        updateGoalState()
    }

    // MARK: - Undo Action

    func undoTodayActivity() {

        guard todayStatus != .none else { return }

        days[todayIndex].status = .none

        let today = calendar.startOfDay(for: Date())
        let key = dateKey(for: today)

        var savedActivities = UserDefaults.standard.dictionary(
            forKey: activityStorageKey
        ) as? [String: String] ?? [:]

        savedActivities.removeValue(forKey: key)

        UserDefaults.standard.set(
            savedActivities,
            forKey: activityStorageKey
        )

        updateGoalState()
    }

    // MARK: - Goal Actions

    func updateGoal(
        newTopic: String,
        newTimeframe: Timeframe
    ) {

        topic = newTopic
        timeframe = newTimeframe

        UserDefaults.standard.set(
            topic,
            forKey: topicStorageKey
        )

        UserDefaults.standard.set(
            timeframe.rawValue,
            forKey: timeframeStorageKey
        )

        resetGoal()
    }

    // MARK: - Goal Logic

    private func updateGoalState() {

        if learnedCount >= goalDays {
            goalState = .completed

        } else if todayStatus == .freezed &&
                    freezedCount >= maxFreezes {
            goalState = .notMet

        } else {
            goalState = .inProgress
        }

        UserDefaults.standard.set(
            goalState.rawValue,
            forKey: goalStateStorageKey
        )
    }

    func resetGoal() {

        goalState = .inProgress

        UserDefaults.standard.set(
            goalState.rawValue,
            forKey: goalStateStorageKey
        )
    }
}
