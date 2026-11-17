
import SwiftUI

// MARK: - Main screen

struct ActivityTask3View: View {

    // MARK: - ViewModel

    @StateObject private var viewModel: ActivityTask3ViewModel

    init(topic: String = "", timeframe: Timeframe = .week) {
        _viewModel = StateObject(
            wrappedValue: ActivityTask3ViewModel(
                topic: topic,
                timeframe: timeframe
            )
        )
    }

    // MARK: - Main UI

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                weekStrip
                statCards
                content
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Content that depends on the goal state

    @ViewBuilder
    private var content: some View {
        switch viewModel.goalState {

        case .inProgress:
            Spacer()
            logButton
            Spacer()
            freezeSection

        case .completed, .notMet:
            Spacer()
            goalResult
            Spacer()
            setGoalButton
        }
    }

    // MARK: - Goal editor

    private var goalEditor: some View {
        LearningGoalView(
            topic: viewModel.topic,
            timeframe: viewModel.timeframe
        ) { newTopic, newTimeframe in
            viewModel.updateGoal(
                newTopic: newTopic,
                newTimeframe: newTimeframe
            )
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Activity")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            HStack(spacing: 12) {
                circleIcon("calendar") {
                    ActivitiesCalendarView()
                }

                circleIcon("pencil.and.outline") {
                    goalEditor
                }
            }
        }
    }

    // A round icon that opens another screen when tapped

    private func circleIcon<Destination: View>(
        _ name: String,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {

        NavigationLink {
            destination()
        } label: {
            Image(systemName: name)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.12), in: Circle())
        }
    }

    // MARK: - Week strip

    private var weekStrip: some View {
        HStack {
            ForEach(viewModel.days) { day in
                VStack(spacing: 8) {
                    Text(day.letter)
                        .font(.caption2)
                        .foregroundStyle(.white)

                    DayCircle(
                        day: day,
                        isToday: day.id == viewModel.days[viewModel.todayIndex].id
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 24)
    }

    // MARK: - Stat cards

    private var statCards: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "flame.fill",
                tint: .appOrange,
                value: viewModel.learnedCount,
                label: "Learned"
            )

            StatCard(
                icon: "snowflake",
                tint: .appBlue,
                value: viewModel.freezedCount,
                label: "Freezed"
            )
        }
        .padding(.top, 16)
    }

    // MARK: - Log button

    private var logButton: some View {
        let isLogged = (viewModel.todayStatus == .learned)

        return Button {
            viewModel.logAsLearned()
        } label: {
            Text(isLogged ? "Logged as Learned" : "Log as Learned")
                .font(.title3.weight(.semibold))
                .foregroundStyle(isLogged ? Color.gray : Color.white)
                .frame(width: 200, height: 200)
                .background(
                    isLogged ? Color.white.opacity(0.1) : Color.appOrange,
                    in: Circle()
                )
        }
        .disabled(isLogged)
    }

    // MARK: - Freeze button

    private var freezeSection: some View {
        VStack(spacing: 12) {

            Button {
                viewModel.freezeDay()
            } label: {
                Text(viewModel.canFreeze ? "Freeze for a day" : "Freezed for a day")
                    .font(.headline)
                    .foregroundStyle(viewModel.canFreeze ? Color.white : Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        viewModel.canFreeze ? Color.appBlue : Color.white.opacity(0.1),
                        in: Capsule()
                    )
            }
            .disabled(!viewModel.canFreeze)

            Text("\(viewModel.freezedCount) out of \(viewModel.maxFreezes) Freezes used")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.bottom, 20)
    }

    // MARK: - Goal result

    private var goalResult: some View {
        let isCompleted = (viewModel.goalState == .completed)

        return VStack(spacing: 8) {
            Image(systemName: isCompleted ? "hands.sparkles.fill" : "xmark.seal.fill")
                .font(.system(size: 52))
                .foregroundStyle(isCompleted ? Color.yellow : Color.appOrange)
                .padding(.bottom, 16)

            Text(isCompleted ? "Well done!" : "You didn't reach your goal this time.")
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(isCompleted ? "Ready for your next goal?" : "Want to set another goal?")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }

    // MARK: - Set a goal button

    private var setGoalButton: some View {
        NavigationLink {
            goalEditor
        } label: {
            Label("Set a goal", systemImage: "pencil.and.outline")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.appOrange, in: Capsule())
        }
        .padding(.bottom, 80)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ActivityTask3View()
    }
}
