import Foundation

struct TempData {
    static let routes:  [ClimbingRoute] = [
        ClimbingRoute(id: UUID(), name: "Summit Peak", difficulty: .beginner, distance: 2.5, elevation: 450, completed: false, progress: 0.0),
        ClimbingRoute(id: UUID(), name: "Eagle's Nest", difficulty: .intermediate, distance: 4.2, elevation: 780, completed: false, progress: 0.0),
        ClimbingRoute(id: UUID(), name: "Dragon's Spine", difficulty: .advanced, distance: 6.8, elevation: 1200, completed: false, progress: 0.0),
        ClimbingRoute(id: UUID(), name: "Heaven's Gate", difficulty: .expert, distance: 9.5, elevation: 2100, completed: false, progress: 0.0),
        ClimbingRoute(id: UUID(), name: "Crystal Ridge", difficulty: .intermediate, distance: 3.7, elevation: 620, completed: false, progress: 0.0),
        ClimbingRoute(id: UUID(), name: "Thunder Wall", difficulty: .advanced, distance: 5.9, elevation: 980, completed: false, progress: 0.0)
    ]
    
    static let teamMembers: [TeamMember] = [
        TeamMember(id: UUID(), name: "Alex Stone", role: "Lead Climber", level: 8, status: .ready),
        TeamMember(id: UUID(), name: "Maya Ridge", role: "Belayer", level: 6, status: .ready),
        TeamMember(id: UUID(), name: "Jake Summit", role: "Navigator", level: 7, status:  .ready),
        TeamMember(id: UUID(), name: "Luna Peak", role: "Support", level: 5, status:  .ready)
    ]
    
    static let challenges: [Challenge] = [
        Challenge(id: UUID(), title: "Balance Master", description: "Test your balance skills on the virtual rock wall", type: .balance, completed: false, reward: 100),
        Challenge(id: UUID(), title: "Speed Climber", description: "Complete the course as fast as possible", type: .speed, completed: false, reward: 150),
        Challenge(id: UUID(), title: "Precision Pro", description: "Hit all targets with perfect accuracy", type: .precision, completed: false, reward: 200),
        Challenge(id:  UUID(), title: "Endurance Test", description: "Survive the longest climbing session", type: .endurance, completed: false, reward: 250)
    ]
}
