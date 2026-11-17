
import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {

    // MARK: - Goal Data

    @Published var topic = ""

    @Published var timeframe: Timeframe = .week

    // MARK: - Actions

    func selectTimeframe(_ option: Timeframe) {
        timeframe = option
    }
}
