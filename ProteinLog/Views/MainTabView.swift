import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var store: ProteinStore

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Today", systemImage: "flame.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Theme.accent)
    }
}

#Preview {
    MainTabView()
        .environmentObject(ProteinStore())
}
