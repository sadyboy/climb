import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var showingImagePicker = false
    
    init(profile: UserProfile) {
        self.profile = profile
    }
    
    func saveProfile() {
        UserProfileStorage.save(profile)
    }
    
    func updateName(_ name: String) {
        profile.name = name
        saveProfile()
    }
    
    func updatePhoto(_ imageData: Data?) {
        profile.photoData = imageData
        saveProfile()
    }
}
