import SwiftUI

struct QuickAddSheet: View {
    let onAdd: (Meal) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var grams: String = ""
    @State private var label: String = ""
    @State private var selectedIcon: String = "🍗"
    @FocusState private var gramsFieldFocused: Bool

    private let icons = ["🍗", "🥩", "🐟", "🥚", "🥛", "🫘", "🥤", "🥗"]
    private let presets = [10, 15, 20, 25, 30, 40, 50]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Log Protein")
                        .font(Theme.comfortaa(24, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top, 8)

                    iconPicker
                    labelField
                    gramsInput
                    presetButtons
                    addButton
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                gramsFieldFocused = true
            }
        }
    }

    // MARK: - Icon Picker

    private var iconPicker: some View {
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
    }

    // MARK: - Label

    private var labelField: some View {
        TextField("Label (optional)", text: $label)
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
    }

    // MARK: - Grams Input

    private var gramsInput: some View {
        HStack {
            TextField("0", text: $grams)
                .keyboardType(.numberPad)
                .font(Theme.comfortaa(36, weight: .bold))
                .foregroundColor(Theme.accent)
                .multilineTextAlignment(.center)
                .focused($gramsFieldFocused)

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
    }

    // MARK: - Presets

    private var presetButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(presets, id: \.self) { preset in
                    Button {
                        grams = "\(preset)"
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Text("\(preset)g")
                            .font(Theme.mono(13))
                            .foregroundColor(grams == "\(preset)" ? .white : Theme.accent)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(grams == "\(preset)" ? Theme.accent : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Theme.border, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            guard let val = Int(grams), val > 0 else { return }
            let meal = Meal(
                grams: val,
                label: label.isEmpty ? "Meal" : label,
                icon: selectedIcon
            )
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onAdd(meal)
            dismiss()
        } label: {
            Text(validGrams ? "Add \(grams)g Protein" : "Enter grams above")
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

    private var validGrams: Bool {
        guard let val = Int(grams) else { return false }
        return val > 0
    }
}

#Preview {
    QuickAddSheet { _ in }
}
