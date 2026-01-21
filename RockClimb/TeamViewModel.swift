import SwiftUI
import Combine

class TeamViewModel:  ObservableObject {
    @Published var teamMembers: [TeamMember] = []
    @Published var selectedMember: TeamMember?
    
    init() {
        loadTeam()
    }
    
    func loadTeam() {
        teamMembers = ClimbingDataStorage.loadTeam()
    }
    
    func updateMemberStatus(_ member: TeamMember, status: TeamMember.Status) {
        if let index = teamMembers.firstIndex(where: { $0.id == member.id }) {
            teamMembers[index].status = status
            ClimbingDataStorage.saveTeam(teamMembers)
        }
    }
    
    func addMember(name: String, role: String, level: Int) {
        let newMember = TeamMember(id: UUID(), name: name, role: role, level: level, status: .ready)
        teamMembers.append(newMember)
        ClimbingDataStorage.saveTeam(teamMembers)
    }
}
