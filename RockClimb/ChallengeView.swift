import SwiftUI

struct ChallengeView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    @State private var animateGradient = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        HeaderView(title: "Challenges", subtitle: "Test your climbing skills")
                            .padding(.top, max(geometry.safeAreaInsets.top + 10, 60))
                        
                        ForEach(viewModel.challenges) { challenge in
                            ChallengeCard(challenge: challenge, viewModel:  viewModel)
                        }
                    }
                    .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 100, 120))
                }
                
                if viewModel.isPlayingChallenge {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    ChallengeGameView(viewModel: viewModel)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            animateGradient = true
        }
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    @ObservedObject var viewModel:  ChallengeViewModel
    @State private var isPressed = false
    
    var challengeIcon: String {
        switch challenge.type {
        case .balance:  return "figure.stand"
        case .speed: return "speedometer"
        case .precision: return "target"
        case .endurance: return "heart.fill"
        }
    }
    
    var challengeColor: Color {
        switch challenge.type {
        case .balance: return .green
        case .speed: return .orange
        case .precision: return .blue
        case .endurance: return .red
        }
    }
    
    var body: some View {
        Button(action: {
            if !challenge.completed {
                HapticManager.shared.impact(style: .heavy)
                viewModel.startChallenge(challenge)
            }
        }) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [challengeColor, challengeColor.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: challengeIcon)
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(challenge.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("+\(challenge.reward) XP")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                }
                
                Spacer()
                
                if challenge.completed {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius:  20)
                            .stroke(challengeColor.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: challengeColor.opacity(0.3), radius: isPressed ? 5 : 15, x: 0, y:  isPressed ? 2 : 8)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(challenge.completed ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(challenge.completed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !challenge.completed {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
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
