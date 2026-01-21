import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @State private var tabOffsets:  [CGFloat] = [0, 0, 0, 0, 0]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                CompassView()
                    .tag(1)
                
                TeamView()
                    .tag(2)
                
                ChallengeView()
                    .tag(3)
                
                SettingsView()
                    .tag(4)
            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
            
            CustomTabBar(selectedTab: $selectedTab, tabOffsets: $tabOffsets)
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .onChange(of: selectedTab) { selectedTab in 
            animateTab(selectedTab)
        }
    }
    
    func animateTab(_ index: Int) {
        for i in 0..<tabOffsets.count {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                tabOffsets[i] = i == index ? -10 : 0
            }
        }
    }
}
