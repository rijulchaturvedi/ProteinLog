import SwiftUI

struct ProgressRing: View {
    let current: Int
    let goal: Int
    var size: CGFloat = 220

    private var progress: Double {
        min(Double(current) / Double(max(goal, 1)), 1.0)
    }

    private var overGoal: Bool {
        current >= goal
    }

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(Theme.bgTertiary, lineWidth: 12)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    overGoal
                        ? AnyShapeStyle(Theme.success)
                        : AnyShapeStyle(Theme.accentGradient),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)

            // Center text
            VStack(spacing: 4) {
                Text("\(current)")
                    .font(Theme.comfortaa(50, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4), value: current)

                Text(overGoal ? "GOAL MET ✓" : "of \(goal)g")
                    .font(Theme.mono(11))
                    .foregroundColor(overGoal ? Theme.success : Theme.accentMuted)
                    .tracking(1)
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ZStack {
        Theme.bgPrimary.ignoresSafeArea()
        ProgressRing(current: 87, goal: 150)
    }
}
