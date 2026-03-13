# ProteinLog

A minimal iOS app for tracking daily protein intake. Built with SwiftUI.

<p align="center">
  <strong>Track · Build · Repeat</strong>
</p>

## What it does

ProteinLog lets you log protein grams per meal throughout the day, see your progress toward a daily goal via an animated ring, and review your history over time. If you forgot to log something yesterday, you can go back and add, edit, or delete meals on any past day.

## Features

- **Progress ring** on the home screen showing grams consumed vs. your daily goal, with a color shift when the goal is met
- **Quick-add sheet** with emoji icon picker, optional label, gram presets, and a number pad
- **Meal cards** with swipe-to-delete (context menu) for today's entries
- **History view** with expandable day rows, per-day progress bars, and full edit support (add, edit, delete meals on any past date)
- **Settings** to adjust your daily protein goal with preset shortcuts
- **Splash screen** with a subtle loading animation on launch
- **Dark mode** support throughout, using an adaptive color system
- **Haptic feedback** on key interactions
- **UserDefaults persistence**, no server or account required

## Requirements

- iOS 17+
- Xcode 15+

## Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/rijulchaturvedi/ProteinLog.git
   ```
2. Open `ProteinLog.xcodeproj` in Xcode.
3. **Fonts**: The app uses the [Comfortaa](https://fonts.google.com/specimen/Comfortaa) font family. Download the font files (`Comfortaa-Regular.ttf`, `Comfortaa-Bold.ttf`, `Comfortaa-SemiBold.ttf`, `Comfortaa-Medium.ttf`, `Comfortaa-Light.ttf`), add them to the Xcode project, and register them in `Info.plist` under `Fonts provided by application`. If the fonts are missing, the app falls back to system fonts.
4. Build and run on a simulator or device.

## Project structure

```
ProteinLog/
├── ProteinLogApp.swift          # App entry point, splash screen logic
├── Models/
│   ├── ProteinStore.swift       # Data model, persistence, CRUD operations
│   └── Theme.swift              # Colors, gradients, fonts, dark mode
└── Views/
    ├── MainTabView.swift        # Tab bar (Today, History, Settings)
    ├── HomeView.swift           # Today's progress, meal list, FAB
    ├── HistoryView.swift        # Past days, expandable rows, edit sheet
    ├── MealCard.swift           # Single meal row component
    ├── ProgressRing.swift       # Animated circular progress indicator
    ├── QuickAddSheet.swift      # Add-a-meal bottom sheet
    ├── SettingsView.swift       # Daily goal configuration
    └── SplashScreen.swift       # Launch animation
```

## License

MIT
