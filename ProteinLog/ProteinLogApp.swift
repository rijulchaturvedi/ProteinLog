import SwiftUI

@main
struct ProteinLogApp: App {
    @StateObject private var store = ProteinStore()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .environmentObject(store)

                if showSplash {
                    SplashScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
