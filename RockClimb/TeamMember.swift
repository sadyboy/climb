import SwiftUI

struct TeamMember: Identifiable, Codable {
    let id: UUID
    var name: String
    var role: String
    var level: Int
    var status: Status
    
    enum Status: String, Codable {
        case ready = "Ready"
        case climbing = "Climbing"
        case resting = "Resting"
    }
}
