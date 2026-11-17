
import SwiftUI

struct StatCard: View {

    let icon: String
    let tint: Color
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 6) {

            Image(systemName: icon)
                .foregroundStyle(tint)

            Text("\(value) \(value == 1 ? "day" : "days")")
                .font(.headline)
                .foregroundStyle(.white)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            Color.white.opacity(0.08),
            in: RoundedRectangle(cornerRadius: 22)
        )
    }
}
