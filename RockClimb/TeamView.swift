import SwiftUI

struct TeamView: View {
    @StateObject private var viewModel = TeamViewModel()
    @State private var animateGradient = false
    @State private var showingAddMember = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        HeaderView(title: "Your Team", subtitle: "Climb together, reach higher")
                            .padding(.top, max(geometry.safeAreaInsets.top + 10, 60))
                        
                        ForEach(viewModel.teamMembers) { member in
                            TeamMemberCard(member:  member, viewModel: viewModel)
                        }
                        
                        AddTeamButton {
                            HapticManager.shared.impact(style: .light)
                            showingAddMember = true
                        }
                    }
                    .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 100, 120))
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showingAddMember) {
            AddTeamMemberView(viewModel: viewModel)
        }
        .onAppear {
            animateGradient = true
        }
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
}

struct TeamMemberCard: View {
    let member: TeamMember
    @ObservedObject var viewModel: TeamViewModel
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Text(String(member.name.prefix(1)))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(member.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(member.role)
                        .font(.system(size: 14, weight:  .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 4) {
                        ForEach(0..<member.level, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Spacer()
                
                StatusBadge(status: member.status)
            }
            
            HStack(spacing: 12) {
                StatusButton(title: "Ready", status: .ready, currentStatus: member.status) {
                    HapticManager.shared.selection()
                    viewModel.updateMemberStatus(member, status: .ready)
                }
                
                StatusButton(title: "Climbing", status: .climbing, currentStatus: member.status) {
                    HapticManager.shared.selection()
                    viewModel.updateMemberStatus(member, status: .climbing)
                }
                
                StatusButton(title:  "Resting", status: .resting, currentStatus: member.status) {
                    HapticManager.shared.selection()
                    viewModel.updateMemberStatus(member, status: .resting)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y:  5)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
    }
}

struct StatusBadge: View {
    let status: TeamMember.Status
    
    var statusColor: Color {
        switch status {
        case .ready: return .green
        case .climbing: return .orange
        case .resting: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(statusColor.opacity(0.2))
        )
    }
}

struct StatusButton: View {
    let title: String
    let status: TeamMember.Status
    let currentStatus: TeamMember.Status
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(currentStatus == status ? .white : .white.opacity(0.5))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(currentStatus == status ? Color.white.opacity(0.2) : Color.clear)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
}

struct AddTeamButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                
                Text("Add Team Member")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}
