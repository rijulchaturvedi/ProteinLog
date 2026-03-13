import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: ProteinStore
    @State private var showAddSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.bgPrimary.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    progressSection
                    statsBar
                    mealsSection
                }
                .padding(.bottom, 100)
            }

            // Floating action button
            fabButton
        }
        .sheet(isPresented: $showAddSheet) {
            QuickAddSheet { meal in
                store.addMeal(meal)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationBackground(Theme.bgSecondary)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ProteinLog")
                    .font(Theme.comfortaa(26, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .font(Theme.comfortaa(12))
                    .foregroundColor(Theme.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Progress

    private var progressSection: some View {
        ProgressRing(current: store.todayTotal, goal: store.dailyGoal)
            .padding(.vertical, 24)
    }

    // MARK: - Stats

    private var statsBar: some View {
        HStack(spacing: 0) {
            statItem(title: "GOAL", value: "\(store.dailyGoal)g", color: Theme.accentMuted)
            divider
            statItem(
                title: "REMAINING",
                value: "\(store.remaining)g",
                color: store.remaining == 0 ? Theme.success : Theme.accent
            )
            divider
            statItem(title: "MEALS", value: "\(store.todayMeals.count)", color: Theme.accentMuted)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
    }

    private func statItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(Theme.mono(10))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            Text(value)
                .font(Theme.comfortaa(20, weight: .semibold))
                .foregroundColor(color)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.4), value: value)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.border)
            .frame(width: 1, height: 36)
    }

    // MARK: - Meals

    private var mealsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TODAY'S MEALS")
                .font(Theme.mono(11))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
                .padding(.horizontal, 20)

            if store.todayMeals.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 28))
                        .foregroundColor(Theme.textDim)
                    Text("Tap + to log your first meal")
                        .font(Theme.comfortaa(14))
                        .foregroundColor(Theme.textDim)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(store.todayMeals) { meal in
                        MealCard(meal: meal) {
                            withAnimation(.spring(response: 0.35)) {
                                store.deleteMeal(id: meal.id)
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - FAB

    private var fabButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(Theme.accentGradient, in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: Theme.accent.opacity(0.35), radius: 16, y: 8)
        }
        .padding(.bottom, 12)
    }
}

#Preview {
    HomeView()
        .environmentObject(ProteinStore())
}
