# ProteinLog - iOS Protein Tracker

A clean, elegant protein tracking app for iPhone built with SwiftUI.

## What's New in v2

- **Lavender purple** color palette with adaptive light/dark mode
- **Comfortaa** rounded font throughout the entire UI
- Auto-switches theme with your system setting

## Features

- Splash screen with animated branding on launch
- Circular progress ring showing daily protein intake vs. goal
- Quick-add bottom sheet with emoji icon picker, preset buttons, and optional labels
- Swipe-to-delete and long-press context menus on meal entries
- Haptic feedback on all interactions
- Daily history with expandable day rows
- Adjustable daily goal with preset quick-select
- Persistent storage via UserDefaults

## Setup in Xcode

### 1. Create a new project
- Open Xcode → File → New → Project
- Select **App** (under iOS)
- Product Name: `ProteinLog`
- Interface: **SwiftUI**
- Language: **Swift**

### 2. Add source files
Delete the default `ContentView.swift` and replace `ProteinLogApp.swift`, then drag in all files from this project.

### 3. Add the Comfortaa Font (IMPORTANT)

The app uses the **Comfortaa** Google Font. Here's how to add it:

1. **Download Comfortaa** from [Google Fonts](https://fonts.google.com/specimen/Comfortaa)
2. Unzip and find these `.ttf` files:
   - `Comfortaa-Regular.ttf`
   - `Comfortaa-Medium.ttf`
   - `Comfortaa-SemiBold.ttf`
   - `Comfortaa-Bold.ttf`
   - `Comfortaa-Light.ttf`
3. **Drag all 5 `.ttf` files** into your Xcode project navigator (into the ProteinLog group)
4. Make sure **"Copy items if needed"** and **"Add to target: ProteinLog"** are both checked
5. Open your app's **Info.plist** (or the Info tab in target settings) and add:
   - Key: `Fonts provided by application` (or `UIAppFonts`)
   - Type: Array
   - Items:
     - `Comfortaa-Regular.ttf`
     - `Comfortaa-Medium.ttf`
     - `Comfortaa-SemiBold.ttf`
     - `Comfortaa-Bold.ttf`
     - `Comfortaa-Light.ttf`

   If your project uses the modern Info tab (no separate Info.plist file):
   - Click the **ProteinLog target** → **Info** tab
   - Under **Custom iOS Target Properties**, click **+**
   - Add `Fonts provided by application` as an Array
   - Add each `.ttf` filename as a String item

### 4. Build & Run
- Select an iPhone simulator or your physical device
- `Cmd + Shift + K` to clean, then `Cmd + R` to run
- Requires **iOS 17.0+** and **Xcode 15+**

## Project Structure

```
ProteinLog/
├── ProteinLogApp.swift        # App entry point + splash logic
├── Models/
│   ├── ProteinStore.swift     # Data model, persistence, business logic
│   └── Theme.swift            # Adaptive colors, gradients, font helpers
├── Views/
│   ├── SplashScreen.swift     # Animated launch screen
│   ├── MainTabView.swift      # Tab bar (Today / History / Settings)
│   ├── HomeView.swift         # Main screen with ring + meal list
│   ├── ProgressRing.swift     # Circular progress component
│   ├── MealCard.swift         # Individual meal entry card
│   ├── QuickAddSheet.swift    # Bottom sheet for adding meals
│   ├── HistoryView.swift      # Past days with expandable details
│   └── SettingsView.swift     # Daily goal configuration
└── Resources/
    └── Comfortaa-*.ttf        # Font files (you add these)
```

## Color Palette

| Element       | Light Mode   | Dark Mode    |
|---------------|-------------|-------------|
| Background    | #F7F5FA     | #16141C     |
| Card          | #FFFFFF     | #1E1B28     |
| Accent        | #7C5CFC     | #9B7FFF     |
| Accent Light  | #A78BFA     | #B8A0FF     |
| Text Primary  | #2D2640     | #F0ECF6     |
| Text Muted    | #8B84A0     | #6E6888     |

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
