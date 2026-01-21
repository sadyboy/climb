import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var showSplash = true
    @Published var userProfile: UserProfile
    
    init() {
        self.userProfile = UserProfileStorage.load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.showSplash = false
            }
        }
    }
}
