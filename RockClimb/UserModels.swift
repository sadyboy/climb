import SwiftUI

struct UserProfile: Codable {
    var name: String
    var photoData: Data?
    var climbingLevel: Int
    var totalClimbs: Int
    var achievements: [String]
    
    static var empty: UserProfile {
        UserProfile(name: "", photoData: nil, climbingLevel: 1, totalClimbs: 0, achievements: [])
    }
}
