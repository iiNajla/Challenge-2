
import SwiftUI

struct ActivitiesCalendarView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel = ActivitiesCalendarViewModel()

    // MARK: - Back Navigation

    @Environment(\.dismiss) private var dismiss

    // MARK: - Grid Layout

    private let columns = Array(
        repeating: GridItem(.flexible()),
        count: 7
    )

    // MARK: - Main View

    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    ForEach(viewModel.months, id: \.self) { month in

                        monthSection(month)

                        if month != viewModel.months.last {
                            monthDivider
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .safeAreaInset(edge: .top) {
            topBar
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }

    // MARK: - Top Bar

    private var topBar: some View {

        ZStack {
            Text("Activities")
                .font(.headline)
                .foregroundStyle(.white)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Color.white.opacity(0.08),
                            in: Circle()
                        )
                }

                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    // MARK: - Month Section

    private func monthSection(_ month: Int) -> some View {

        let first = viewModel.firstDate(of: month)
        let offset = viewModel.weekdayOffset(for: month)
        let dayCount = viewModel.dayCount(for: month)

        return VStack(alignment: .leading, spacing: 14) {

            Text(first.formatted(.dateTime.month(.wide).year()))
                .font(.headline)
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 10) {

                // Weekday Names

                ForEach(viewModel.weekdays, id: \.self) { name in
                    Text(name)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.gray)
                }

                // Empty Cells

                ForEach(0..<offset, id: \.self) { _ in
                    Color.clear
                        .frame(height: 40)
                }

                // Calendar Days

                ForEach(1...dayCount, id: \.self) { day in

                    DayCircle(
                        day: CalendarDay(
                            letter: "",
                            number: day,
                            status: viewModel.status(
                                month: month,
                                day: day
                            )
                        ),
                        isToday: viewModel.isToday(
                            month: month,
                            day: day
                        )
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - Month Divider

    private var monthDivider: some View {

        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(height: 1)
            .padding(.vertical, 20)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ActivitiesCalendarView()
    }
}
