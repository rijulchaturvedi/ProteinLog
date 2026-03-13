import SwiftUI

struct MealCard: View {
    let meal: Meal
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Text(meal.icon)
                .font(.system(size: 20))
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.accentSubtle)
                )

            // Label & time
            VStack(alignment: .leading, spacing: 2) {
                Text(meal.label)
                    .font(Theme.comfortaa(15, weight: .medium))
                    .foregroundColor(Theme.textPrimary)

                Text(meal.time.formatted(date: .omitted, time: .shortened))
                    .font(Theme.mono(11))
                    .foregroundColor(Theme.textMuted)
            }

            Spacer()

            // Grams
            Text("\(meal.grams)g")
                .font(Theme.comfortaa(22, weight: .bold))
                .foregroundColor(Theme.accent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgCard)
                .shadow(color: Theme.accent.opacity(0.04), radius: 8, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Theme.border, lineWidth: 1)
                )
        )
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.bgPrimary.ignoresSafeArea()
        VStack(spacing: 10) {
            MealCard(meal: Meal(grams: 35, label: "Chicken Breast", icon: "🍗"), onDelete: {})
            MealCard(meal: Meal(grams: 20, label: "Greek Yogurt", icon: "🥛"), onDelete: {})
        }
        .padding()
    }
}
