import SwiftUI

struct AddTeamMemberView: View {
    @ObservedObject var viewModel: TeamViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var role = ""
    @State private var level = 1
    @State private var animateGradient = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        HStack {
                            Spacer()
                            Button(action: {
                                HapticManager.shared.impact(style: .light)
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .padding(.top, max(geometry.safeAreaInsets.top, 10))
                        
                        VStack(spacing: 12) {
                            Image(systemName: "person.badge.plus.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors:  [.blue, .purple],
                                        startPoint:  .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Add Team Member")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            EnhancedTextField(
                                title: "Name",
                                text: $name,
                                icon: "person.fill",
                                placeholder: "Enter name"
                            )
                            
                            EnhancedTextField(
                                title: "Role",
                                text: $role,
                                icon: "briefcase.fill",
                                placeholder: "e.g., Lead Climber"
                            )
                            
                            LevelSelector(level: $level)
                        }
                        
                        Spacer(minLength: 30)
                        
                        VStack(spacing: 16) {
                            AnimatedPrimaryButton(
                                title:  "Add to Team",
                                icon: "checkmark.circle.fill",
                                gradient: [.blue, .purple]
                            ) {
                                HapticManager.shared.notification(type: .success)
                                viewModel.addMember(name:  name, role: role, level:  level)
                                dismiss()
                            }
                            .disabled(name.isEmpty || role.isEmpty)
                            .opacity(name.isEmpty || role.isEmpty ? 0.5 : 1.0)
                            
                            AnimatedSecondaryButton(title: "Cancel", icon:  "xmark") {
                                HapticManager.shared.impact(style: .light)
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 30))
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
}

struct EnhancedTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder:  String
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: isFocused ?
                                        [Color.blue, Color.purple] :
                                        [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: isFocused ? 2 :  1
                                )
                        )
                )
                .autocapitalization(.words)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        isFocused = true
                    }
                }
        }
    }
}

struct LevelSelector: View {
    @Binding var level: Int
    @State private var showStars = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.yellow)
                
                Text("Skill Level:  \(level)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(spacing: 16) {
                HStack(spacing: 4) {
                    ForEach(1...level, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                            .scaleEffect(showStars ? 1.0 : 0.5)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(Double(index) * 0.05), value: showStars)
                    }
                    ForEach(level + 1...10, id: \.self) { _ in
                        Image(systemName: "star")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.4))
                    }
                }
                .frame(maxWidth: .infinity)
                
                Slider(
                    value:  Binding(
                        get: { Double(level) },
                        set: {
                            level = Int($0)
                            showStars = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    showStars = true
                                }
                            }
                            HapticManager.shared.selection()
                        }
                    ),
                    in: 1...10,
                    step: 1
                )
                .tint(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth:  1.5
                            )
                    )
            )
        }
        .onAppear {
            showStars = true
        }
    }
}
