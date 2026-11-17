import SwiftUI

struct LearningGoalView: View {

    // Lets us close this screen (back button / after Update)
    @Environment(\.dismiss) private var dismiss

    // The values the user can edit
    @State private var topic: String
    @State private var timeframe: Timeframe

    // Controls the "Update goal" alert
    @State private var showAlert = false

    // Lets us hide the keyboard by tapping outside the text field
    @FocusState private var isFocused: Bool

    // Called when the user confirms "Update" (the Activity screen uses it to save the new goal)
    private let onUpdate: (String, Timeframe) -> Void

    // Start with the current goal (defaults match the design)
    init(
        topic: String = "",
        timeframe: Timeframe = .week,
        onUpdate: @escaping (String, Timeframe) -> Void = { _, _ in }
    ) {
        _topic = State(initialValue: topic)
        _timeframe = State(initialValue: timeframe)
        self.onUpdate = onUpdate
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .onTapGesture { isFocused = false }

            VStack(alignment: .leading, spacing: 0) {
                topBar
                topicSection
                timeframeSection
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
        .alert("Update goal", isPresented: $showAlert) {
            Button("Dismiss", role: .cancel) { }
            Button("Update") {
                onUpdate(topic, timeframe)   // send the new goal back to the previous screen
                dismiss()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
        .tint(Color.appOrange)
    }

    // MARK: Top bar (back button, title, check button)

    private var topBar: some View {
        ZStack {
            Text("Learning Goal")
                .font(.headline)
                .foregroundStyle(.white)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.12), in: Circle())
                }

                Spacer()

                Button {
                    isFocused = false
                    showAlert = true
                } label: {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.appOrange, in: Circle())
                }
            }
        }
        .padding(.top, 8)
    }

    // MARK: Topic input

    private var topicSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("I want to learn")
                .foregroundStyle(.white)
                .padding(.top, 48)

            TextField("", text: $topic, prompt: Text("Swift").foregroundColor(.gray))
                .foregroundStyle(.white)
                .focused($isFocused)
                .padding(.top, 12)

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)
                .padding(.top, 10)
        }
    }

    // MARK: Timeframe chips

    private var timeframeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("I want to learn it in a")
                .foregroundStyle(.white)
                .padding(.top, 36)

            HStack(spacing: 10) {
                ForEach(Timeframe.allCases) { option in
                    let isSelected = (option == timeframe)

                    Button {
                        timeframe = option
                    } label: {
                        Text(option.rawValue)
                            .font(.headline)
                            .foregroundStyle(isSelected ? Color.white : Color.gray)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 12)
                            .background(
                                isSelected ? Color.appOrange : Color.white.opacity(0.1),
                                in: Capsule()
                            )
                    }
                }
            }
            .padding(.top, 14)
        }
    }
}

#Preview {
    NavigationStack {
        LearningGoalView()
    }
}
