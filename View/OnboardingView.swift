
import SwiftUI

struct OnboardingView: View {

    @StateObject private var viewModel = OnboardingViewModel()

    private let accent = Color.appOrange

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(accent)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)

                HStack(spacing: 8) {
                    Text("Hello")
                        .font(.system(size: 34))

                    Text("Learner")
                        .font(.system(size: 34, weight: .bold))
                }
                .foregroundStyle(.white)
                .padding(.top, 40)

                Text("This app will help you learn everyday!")
                    .foregroundStyle(.gray)
                    .padding(.top, 4)

                Text("I want to learn")
                    .foregroundStyle(.white)
                    .padding(.top, 36)

                TextField(
                    "",
                    text: $viewModel.topic,
                    prompt: Text("Swift").foregroundColor(.gray)
                )
                .foregroundStyle(.white)
                .padding(.top, 12)

                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 1)
                    .padding(.top, 10)

                Text("I want to learn it in a")
                    .foregroundStyle(.white)
                    .padding(.top, 36)

                HStack(spacing: 10) {
                    ForEach(Timeframe.allCases) { option in

                        let isSelected = (option == viewModel.timeframe)

                        Button {
                            viewModel.selectTimeframe(option)
                        } label: {
                            Text(option.rawValue)
                                .font(.headline)
                                .foregroundStyle(
                                    isSelected ? Color.white : Color.gray
                                )
                                .padding(.horizontal, 22)
                                .padding(.vertical, 12)
                                .background(
                                    isSelected ? accent : Color.white.opacity(0.1),
                                    in: Capsule()
                                )
                        }
                    }
                }
                .padding(.top, 14)

                Spacer()

                VStack(spacing: 10) {
                    NavigationLink {
                        ActivityTask3View(
                            topic: viewModel.topic,
                            timeframe: viewModel.timeframe
                        )
                    } label: {
                        Text("Start Learning")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(accent, in: Capsule())
                    }

                    Text("You can edit your desire later")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}
