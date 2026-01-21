import SwiftUI

@main
struct RockClimbApp: App {
    @StateObject private var appState = AppState()
    init() {
          let appearance = UITabBarAppearance()
          appearance.configureWithTransparentBackground()
          appearance.backgroundColor = .clear

          UITabBar.appearance().standardAppearance = appearance
          UITabBar.appearance().scrollEdgeAppearance = appearance
      }
    var body: some Scene {
        WindowGroup {
            if appState.showSplash {
                SplashView()
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environmentObject(appState)
            }
        }
    }
}
