import Foundation
import SwiftUI
import Combine

// MARK: - Models

struct Meal: Identifiable, Codable {
    let id: UUID
    var grams: Int
    var label: String
    var icon: String
    var time: Date

    init(grams: Int, label: String = "Meal", icon: String = "🍗", time: Date = .now) {
        self.id = UUID()
        self.grams = grams
        self.label = label
        self.icon = icon
        self.time = time
    }
}

struct DayRecord: Codable {
    var dateKey: String
    var meals: [Meal]

    var totalGrams: Int {
        meals.reduce(0) { $0 + $1.grams }
    }
}

// MARK: - Store

class ProteinStore: ObservableObject {
    @Published var days: [String: [Meal]] = [:]
    @Published var dailyGoal: Int = 150

    private let daysKey = "ProteinLog_days"
    private let goalKey = "ProteinLog_goal"

    init() {
        loadData()
    }

    // MARK: - Computed

    var todayKey: String {
        Self.dateKey(for: .now)
    }

    var todayMeals: [Meal] {
        days[todayKey] ?? []
    }

    var todayTotal: Int {
        todayMeals.reduce(0) { $0 + $1.grams }
    }

    var remaining: Int {
        max(0, dailyGoal - todayTotal)
    }

    var sortedDayKeys: [String] {
        days.keys.sorted().reversed()
    }

    static func dateKey(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    static func displayDate(from key: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        guard let date = f.date(from: key) else { return key }
        let display = DateFormatter()
        display.dateFormat = "EEE, MMM d"
        return display.string(from: date)
    }

    // MARK: - Actions

    func addMeal(_ meal: Meal) {
        addMeal(meal, forKey: todayKey)
    }

    func addMeal(_ meal: Meal, forKey dayKey: String) {
        var meals = days[dayKey] ?? []
        meals.append(meal)
        days[dayKey] = meals
        saveData()
    }

    func deleteMeal(at index: Int) {
        guard var meals = days[todayKey], index < meals.count else { return }
        meals.remove(at: index)
        days[todayKey] = meals.isEmpty ? nil : meals
        saveData()
    }

    func deleteMeal(id: UUID) {
        deleteMeal(id: id, forKey: todayKey)
    }

    func deleteMeal(id: UUID, forKey dayKey: String) {
        guard var meals = days[dayKey] else { return }
        meals.removeAll { $0.id == id }
        days[dayKey] = meals.isEmpty ? nil : meals
        saveData()
    }

    func updateMeal(id: UUID, forKey dayKey: String, newGrams: Int? = nil, newLabel: String? = nil, newIcon: String? = nil) {
        guard var meals = days[dayKey] else { return }
        if let idx = meals.firstIndex(where: { $0.id == id }) {
            if let g = newGrams { meals[idx].grams = g }
            if let l = newLabel { meals[idx].label = l }
            if let i = newIcon { meals[idx].icon = i }
            days[dayKey] = meals
            saveData()
        }
    }

    func updateGoal(_ goal: Int) {
        dailyGoal = max(1, goal)
        saveData()
    }

    // MARK: - Persistence

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(days) {
            UserDefaults.standard.set(encoded, forKey: daysKey)
        }
        UserDefaults.standard.set(dailyGoal, forKey: goalKey)
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: daysKey),
           let decoded = try? JSONDecoder().decode([String: [Meal]].self, from: data) {
            days = decoded
        }
        let savedGoal = UserDefaults.standard.integer(forKey: goalKey)
        if savedGoal > 0 {
            dailyGoal = savedGoal
        }
    }
}
