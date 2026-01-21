import SwiftUI

struct Challenge:  Identifiable {
    let id: UUID
    var title: String
    var description: String
    var type: ChallengeType
    var completed: Bool
    var reward: Int
    
    enum ChallengeType {
        case balance
        case speed
        case precision
        case endurance
    }
}
