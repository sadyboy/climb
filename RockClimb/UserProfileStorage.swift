import Foundation

struct UserProfileStorage {
    private static let key = "userProfile"
    
    static func save(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func load() -> UserProfile {
        guard let data = UserDefaults.standard.data(forKey: key),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return UserProfile.empty
        }
        return profile
    }
}
