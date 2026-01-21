import Foundation

struct ClimbingDataStorage {
    private static let routesKey = "climbingRoutes"
    private static let teamKey = "teamMembers"
    
    static func saveRoutes(_ routes: [ClimbingRoute]) {
        if let encoded = try? JSONEncoder().encode(routes) {
            UserDefaults.standard.set(encoded, forKey: routesKey)
        }
    }
    
    static func loadRoutes() -> [ClimbingRoute] {
        guard let data = UserDefaults.standard.data(forKey: routesKey),
              let routes = try? JSONDecoder().decode([ClimbingRoute].self, from: data) else {
            return TempData.routes
        }
        return routes
    }
    
    static func saveTeam(_ team: [TeamMember]) {
        if let encoded = try? JSONEncoder().encode(team) {
            UserDefaults.standard.set(encoded, forKey: teamKey)
        }
    }
    
    static func loadTeam() -> [TeamMember] {
        guard let data = UserDefaults.standard.data(forKey: teamKey),
              let team = try? JSONDecoder().decode([TeamMember].self, from: data) else {
            return TempData.teamMembers
        }
        return team
    }
}
