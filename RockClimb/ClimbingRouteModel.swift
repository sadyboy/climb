import SwiftUI

struct ClimbingRoute: Identifiable, Codable {
    let id:  UUID
    var name: String
    var difficulty:  Difficulty
    var distance: Double
    var elevation: Double
    var completed: Bool
    var progress: Double
    
    enum Difficulty: String, Codable, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        case expert = "Expert"
        
        var color: Color {
            switch self {
            case .beginner: return .green
            case .intermediate: return .blue
            case .advanced: return .orange
            case .expert: return .red
            }
        }
    }
}
