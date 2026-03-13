import SwiftUI

struct SplashScreen: View {
    @State private var showContent = false
    @State private var progress: CGFloat = 0

    var body: some View {
        ZStack {
            Theme.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Icon
                Text("🍗")
                    .font(.system(size: 64))
                    .blur(radius: showContent ? 0 : 8)
                    .scaleEffect(showContent ? 1 : 0.9)
                    .opacity(showContent ? 1 : 0)

                // App name
                Text("ProteinLog")
                    .font(Theme.comfortaa(38, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .padding(.top, 12)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 15)

                // Tagline
                Text("TRACK · BUILD · REPEAT")
                    .font(Theme.mono(11))
                    .foregroundColor(Theme.accentMuted)
                    .tracking(2)
                    .padding(.top, 10)
                    .opacity(showContent ? 1 : 0)

                Spacer()

                // Progress bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.bgTertiary)
                    .frame(width: 40, height: 3)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.accentGradient)
                            .frame(width: 40 * progress, height: 3)
                    }
                    .padding(.bottom, 80)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 1.4)) {
                progress = 1
            }
        }
    }
}

#Preview {
    SplashScreen()
}
