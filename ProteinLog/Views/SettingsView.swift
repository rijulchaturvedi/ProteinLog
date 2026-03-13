import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: ProteinStore
    @State private var goalText: String = ""
    @State private var showSaved = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        goalCard
                        appInfo
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                goalText = "\(store.dailyGoal)"
            }
        }
    }

    // MARK: - Goal Card

    private var goalCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Daily Goal", systemImage: "target")
                .font(Theme.comfortaa(13, weight: .semibold))
                .foregroundColor(Theme.accentMuted)

            HStack(spacing: 12) {
                TextField("150", text: $goalText)
                    .keyboardType(.numberPad)
                    .font(Theme.comfortaa(32, weight: .bold))
                    .foregroundColor(Theme.accent)
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Theme.bgTertiary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(Theme.border, lineWidth: 1)
                            )
                    )

                Text("grams")
                    .font(Theme.mono(14))
                    .foregroundColor(Theme.textMuted)
            }

            // Quick presets
            HStack(spacing: 8) {
                ForEach([100, 120, 150, 180, 200], id: \.self) { preset in
                    Button {
                        goalText = "\(preset)"
                        saveGoal(preset)
                    } label: {
                        Text("\(preset)g")
                            .font(Theme.mono(12))
                            .foregroundColor(store.dailyGoal == preset ? .white : Theme.accent)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(store.dailyGoal == preset ? Theme.accent : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(Theme.border, lineWidth: 1)
                                    )
                            )
                    }
                }
            }

            Button {
                guard let val = Int(goalText), val > 0 else { return }
                saveGoal(val)
            } label: {
                HStack {
                    if showSaved {
                        Image(systemName: "checkmark")
                        Text("Saved!")
                    } else {
                        Text("Update Goal")
                    }
                }
                .font(Theme.comfortaa(15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.accentGradient)
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.bgCard)
                .shadow(color: Theme.accent.opacity(0.04), radius: 8, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Theme.border, lineWidth: 1)
                )
        )
    }

    // MARK: - App Info

    private var appInfo: some View {
        VStack(spacing: 12) {
            Text("🍗")
                .font(.system(size: 36))

            Text("ProteinLog")
                .font(Theme.comfortaa(20, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Text("Track · Build · Repeat")
                .font(Theme.mono(11))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)

            Text("v1.0")
                .font(Theme.mono(11))
                .foregroundColor(Theme.textDim)
                .padding(.top, 4)
        }
        .padding(.top, 20)
    }

    private func saveGoal(_ val: Int) {
        store.updateGoal(val)
        goalText = "\(val)"
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation { showSaved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showSaved = false }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProteinStore())
}
