import SwiftUI

struct RouteDetailView: View {
    let route: ClimbingRoute
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var progress: Double = 0
    @State private var isClimbing = false
    @State private var animateCircle = false
    @State private var showParticles = false
    @State private var rotation: Double = 0
    @State private var showDetailInfo = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        closeButton
                            .padding(.top, max(geometry.safeAreaInsets.top, 10))
                        
                        progressCircle(screenWidth: geometry.size.width)
                            .padding(.top, 20)
                        
                        routeInfo
                        
                        statsGrid(screenWidth: geometry.size.width)
                        
                        actionButtons
                        
                        achievementSection
                    }
                    .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 30, 30))
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showDetailInfo) {
            RouteFullDetailsView(route: route)
        }
        .onAppear {
            progress = route.progress
            withAnimation(.linear(duration: 20).repeatForever(autoreverses:  false)) {
                rotation = 360
            }
        }
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                HapticManager.shared.impact(style: .light)
                dismiss()
            }) {
                Image(systemName:  "xmark")
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
    }
    
    private func progressCircle(screenWidth: CGFloat) -> some View {
        let circleSize = min(screenWidth * 0.5, 220)
        
        return ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(lineWidth: 1)
                    .foregroundColor(.white.opacity(0.1))
                    .frame(width: circleSize + CGFloat(index * 20), height: circleSize + CGFloat(index * 20))
                    .scaleEffect(animateCircle ?  1.1 : 1.0)
                    .opacity(animateCircle ? 0.3 : 0.6)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: animateCircle
                    )
            }
            
            Circle()
                .stroke(lineWidth: 14)
                .foregroundColor(.white.opacity(0.1))
                .frame(width: circleSize, height: circleSize)
            
            Circle()
                .trim(from: 0, to:  progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            route.difficulty.color,
                            route.difficulty.color.opacity(0.7),
                            route.difficulty.color,
                            route.difficulty.color.opacity(0.7),
                            route.difficulty.color
                        ],
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
                .shadow(color: route.difficulty.color.opacity(0.6), radius: 10, x: 0, y:  0)
            
            VStack(spacing: 12) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: min(circleSize * 0.22, 48), weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.8)],
                            startPoint:  .top,
                            endPoint: .bottom
                        )
                    )
                
                Text("Complete")
                    .font(.system(size: min(circleSize * 0.08, 16), weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                if progress >= 1.0 {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            animateCircle = true
        }
    }
    
    private var routeInfo: some View {
        VStack(spacing: 12) {
            Text(route.name)
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 6) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 14))
                Text(route.difficulty.rawValue)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(route.difficulty.color)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(route.difficulty.color.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(route.difficulty.color.opacity(0.5), lineWidth: 1.5)
                    )
            )
        }
    }
    
    private func statsGrid(screenWidth: CGFloat) -> some View {
        let columns = [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15)
        ]
        
        return LazyVGrid(columns: columns, spacing: 15) {
            EnhancedStatBox(
                icon: "arrow.up.right",
                label: "Elevation",
                value: "\(Int(route.elevation))m",
                color: .orange,
                gradient: [Color.orange, Color.red]
            )
            
            EnhancedStatBox(
                icon: "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath",
                label: "Distance",
                value: String(format: "%.1f km", route.distance),
                color: .blue,
                gradient: [Color.blue, Color.cyan]
            )
            
            EnhancedStatBox(
                icon: "clock.fill",
                label: "Duration",
                value: "\(Int(route.distance * 45)) min",
                color: .purple,
                gradient: [Color.purple, Color.pink]
            )
            
            EnhancedStatBox(
                icon: "flame.fill",
                label: "Difficulty",
                value: route.difficulty.rawValue,
                color: route.difficulty.color,
                gradient: [route.difficulty.color, route.difficulty.color.opacity(0.6)]
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            AnimatedPrimaryButton(
                title: isClimbing ? "Climbing..." : (progress >= 1.0 ? "Completed!" : "Start Climb"),
                icon: isClimbing ? "figure.climbing" : "play.fill",
                isLoading: isClimbing,
                gradient: [route.difficulty.color, route.difficulty.color.opacity(0.7)]
            ) {
                HapticManager.shared.impact(style: .medium)
                startClimbing()
            }
            .disabled(progress >= 1.0)
            
            AnimatedSecondaryButton(title: "View Full Details", icon: "info.circle.fill") {
                HapticManager.shared.impact(style: .light)
                showDetailInfo = true
            }
        }
    }
    
    private var achievementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    AchievementBadge(icon: "star.fill", title: "First Step", unlocked: progress > 0)
                    AchievementBadge(icon: "bolt.fill", title: "Half Way", unlocked: progress >= 0.5)
                    AchievementBadge(icon: "crown.fill", title: "Summit", unlocked: progress >= 1.0)
                    AchievementBadge(icon: "flame.fill", title: "Speed Run", unlocked: false)
                }
            }
        }
        .padding(.top, 10)
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
    
    func startClimbing() {
        guard progress < 1.0 else { return }
        isClimbing = true
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if progress < 1.0 {
                progress += 0.01
                viewModel.updateRouteProgress(route, progress:  progress)
                
                if Int(progress * 100) % 10 == 0 {
                    HapticManager.shared.selection()
                }
            } else {
                timer.invalidate()
                isClimbing = false
                HapticManager.shared.notification(type: .success)
            }
        }
    }
}
