import SwiftUI

// MARK: - Adaptive Color Helper

extension Color {
    /// Creates a color that adapts to light/dark mode
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Theme

enum Theme {

    // ── Backgrounds ──

    static let bgPrimary = Color.adaptive(
        light: Color(hex: "#F7F5FA"),   // soft lavender white
        dark:  Color(hex: "#16141C")    // deep plum black
    )
    static let bgSecondary = Color.adaptive(
        light: Color(hex: "#EEEAF4"),   // light lavender gray
        dark:  Color(hex: "#1E1B28")    // dark purple-gray
    )
    static let bgTertiary = Color.adaptive(
        light: Color(hex: "#E5E0EE"),   // muted lilac
        dark:  Color(hex: "#252230")    // medium plum
    )
    static let bgCard = Color.adaptive(
        light: .white,
        dark:  Color(hex: "#1E1B28")
    )

    // ── Accent (Violet / Purple) ──

    static let accent = Color.adaptive(
        light: Color(hex: "#7C5CFC"),   // vibrant violet
        dark:  Color(hex: "#9B7FFF")    // lighter violet for dark bg
    )
    static let accentLight = Color.adaptive(
        light: Color(hex: "#A78BFA"),   // soft purple
        dark:  Color(hex: "#B8A0FF")    // pastel violet
    )
    static let accentMuted = Color.adaptive(
        light: Color(hex: "#8B7AAE"),   // dusty purple
        dark:  Color(hex: "#7E6FAA")    // muted plum
    )
    static let accentSubtle = Color.adaptive(
        light: Color(hex: "#EDE8F5"),   // barely-there lavender
        dark:  Color(hex: "#2A2540")    // deep purple tint
    )

    // ── Text ──

    static let textPrimary = Color.adaptive(
        light: Color(hex: "#2D2640"),   // deep plum
        dark:  Color(hex: "#F0ECF6")    // off-white lavender
    )
    static let textSecondary = Color.adaptive(
        light: Color(hex: "#4A4360"),   // medium plum
        dark:  Color(hex: "#D4CEE0")    // light lavender
    )
    static let textMuted = Color.adaptive(
        light: Color(hex: "#8B84A0"),   // gray-purple
        dark:  Color(hex: "#6E6888")    // dusty lavender
    )
    static let textDim = Color.adaptive(
        light: Color(hex: "#B8B2C8"),   // pale purple
        dark:  Color(hex: "#3E3854")    // dark muted purple
    )

    // ── Borders ──

    static let border = Color.adaptive(
        light: Color(hex: "#DDD8E8"),   // light lilac border
        dark:  Color(hex: "#302C40")    // dark purple border
    )
    static let borderSubtle = Color.adaptive(
        light: Color(hex: "#EAE6F2"),   // barely-there border
        dark:  Color(hex: "#242030")    // very subtle dark border
    )

    // ── Status ──

    static let success = Color(hex: "#4ADE80")

    // ── Gradients ──

    static let accentGradient = LinearGradient(
        colors: [accent, accentLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // ── Font Helpers ──
    // Comfortaa must be bundled. See README for setup.

    static func comfortaa(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return .custom("Comfortaa-Bold", size: size)
        case .semibold:
            return .custom("Comfortaa-SemiBold", size: size)
        case .medium:
            return .custom("Comfortaa-Medium", size: size)
        case .light:
            return .custom("Comfortaa-Light", size: size)
        default:
            return .custom("Comfortaa-Regular", size: size)
        }
    }

    static func mono(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}

// MARK: - Hex Color Init

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
