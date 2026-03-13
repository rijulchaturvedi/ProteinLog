import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: ProteinStore

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgPrimary.ignoresSafeArea()

                if store.sortedDayKeys.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(store.sortedDayKeys, id: \.self) { dayKey in
                                DayRow(dayKey: dayKey, meals: store.days[dayKey] ?? [], goal: store.dailyGoal)
                                    .environmentObject(store)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundColor(Theme.textDim)
            Text("No history yet")
                .font(Theme.comfortaa(16, weight: .medium))
                .foregroundColor(Theme.textDim)
            Text("Start tracking to see your daily logs here")
                .font(Theme.comfortaa(13))
                .foregroundColor(Theme.textMuted)
        }
    }
}

// MARK: - Day Row

struct DayRow: View {
    @EnvironmentObject var store: ProteinStore
    let dayKey: String
    let meals: [Meal]
    let goal: Int

    private var total: Int { meals.reduce(0) { $0 + $1.grams } }
    private var progress: Double { min(Double(total) / Double(max(goal, 1)), 1.0) }
    private var isToday: Bool { dayKey == ProteinStore.dateKey(for: .now) }
    private var metGoal: Bool { total >= goal }

    @State private var expanded = false
    @State private var showAddSheet = false
    @State private var editingMeal: Meal? = nil

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35)) { expanded.toggle() }
            } label: {
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(isToday ? "Today" : ProteinStore.displayDate(from: dayKey))
                                .font(Theme.comfortaa(15, weight: .medium))
                                .foregroundColor(Theme.textPrimary)

                            Text("\(meals.count) meal\(meals.count != 1 ? "s" : "")")
                                .font(Theme.mono(11))
                                .foregroundColor(Theme.textMuted)
                        }

                        Spacer()

                        Text("\(total)g")
                            .font(Theme.comfortaa(24, weight: .bold))
                            .foregroundColor(metGoal ? Theme.success : Theme.accent)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.textMuted)
                            .rotationEffect(.degrees(expanded ? 90 : 0))
                    }

                    // Progress bar
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.bgTertiary)
                            .frame(height: 5)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(metGoal
                                          ? LinearGradient(colors: [.green.opacity(0.6), Theme.success], startPoint: .leading, endPoint: .trailing)
                                          : Theme.accentGradient
                                    )
                                    .frame(width: geo.size.width * progress, height: 5)
                            }
                    }
                    .frame(height: 5)
                }
            }
            .buttonStyle(.plain)
            .padding(16)

            if expanded {
                Divider()
                    .background(Theme.border)

                VStack(spacing: 6) {
                    ForEach(meals) { meal in
                        HStack(spacing: 10) {
                            Text(meal.icon)
                                .font(.system(size: 16))
                                .frame(width: 28)

                            Text(meal.label)
                                .font(Theme.comfortaa(14))
                                .foregroundColor(Theme.textSecondary)

                            Spacer()

                            Text(meal.time.formatted(date: .omitted, time: .shortened))
                                .font(Theme.mono(11))
                                .foregroundColor(Theme.textMuted)

                            Text("\(meal.grams)g")
                                .font(Theme.mono(14))
                                .foregroundColor(Theme.accent)
                                .frame(width: 44, alignment: .trailing)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button {
                                editingMeal = meal
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                withAnimation(.spring(response: 0.35)) {
                                    store.deleteMeal(id: meal.id, forKey: dayKey)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }

                    // Add meal button for this day
                    Button {
                        showAddSheet = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 14))
                            Text("Add meal")
                                .font(Theme.comfortaa(13, weight: .medium))
                        }
                        .foregroundColor(Theme.accent)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgCard)
                .shadow(color: Theme.accent.opacity(0.03), radius: 6, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(isToday ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1)
                )
        )
        .sheet(isPresented: $showAddSheet) {
            QuickAddSheet { meal in
                store.addMeal(meal, forKey: dayKey)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationBackground(Theme.bgSecondary)
        }
        .sheet(item: $editingMeal) { meal in
            EditMealSheet(meal: meal, dayKey: dayKey)
                .environmentObject(store)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(Theme.bgSecondary)
        }
    }
}

// MARK: - Edit Meal Sheet

struct EditMealSheet: View {
    @EnvironmentObject var store: ProteinStore
    @Environment(\.dismiss) private var dismiss

    let meal: Meal
    let dayKey: String

    @State private var grams: String
    @State private var label: String
    @State private var selectedIcon: String

    private let icons = ["🍗", "🥩", "🐟", "🥚", "🥛", "🫘", "🥤", "🥗"]

    init(meal: Meal, dayKey: String) {
        self.meal = meal
        self.dayKey = dayKey
        _grams = State(initialValue: "\(meal.grams)")
        _label = State(initialValue: meal.label)
        _selectedIcon = State(initialValue: meal.icon)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Edit Meal")
                        .font(Theme.comfortaa(24, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top, 8)

                    // Icon picker
                    HStack(spacing: 8) {
                        ForEach(icons, id: \.self) { icon in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedIcon = icon
                                }
                            } label: {
                                Text(icon)
                                    .font(.system(size: 22))
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedIcon == icon ? Theme.accentSubtle : Theme.bgTertiary)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .strokeBorder(
                                                        selectedIcon == icon ? Theme.accent : Color.clear,
                                                        lineWidth: 2
                                                    )
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Label field
                    TextField("Label", text: $label)
                        .font(Theme.comfortaa(15))
                        .foregroundColor(Theme.textPrimary)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.bgCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Theme.border, lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)

                    // Grams input
                    HStack {
                        TextField("0", text: $grams)
                            .keyboardType(.numberPad)
                            .font(Theme.comfortaa(36, weight: .bold))
                            .foregroundColor(Theme.accent)
                            .multilineTextAlignment(.center)

                        Text("grams")
                            .font(Theme.mono(14))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.bgCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Theme.border, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)

                    // Save button
                    Button {
                        guard let val = Int(grams), val > 0 else { return }
                        store.updateMeal(
                            id: meal.id,
                            forKey: dayKey,
                            newGrams: val,
                            newLabel: label.isEmpty ? nil : label,
                            newIcon: selectedIcon
                        )
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        dismiss()
                    } label: {
                        Text(validGrams ? "Save Changes" : "Enter grams above")
                            .font(Theme.comfortaa(17, weight: .semibold))
                            .foregroundColor(validGrams ? .white : Theme.textMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(validGrams ? AnyShapeStyle(Theme.accentGradient) : AnyShapeStyle(Theme.bgTertiary))
                            )
                    }
                    .disabled(!validGrams)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            .background(Theme.bgSecondary.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                        .font(Theme.comfortaa(15))
                        .foregroundColor(Theme.accentMuted)
                }
            }
        }
    }

    private var validGrams: Bool {
        guard let val = Int(grams) else { return false }
        return val > 0
    }
}

#Preview {
    HistoryView()
        .environmentObject(ProteinStore())
}
