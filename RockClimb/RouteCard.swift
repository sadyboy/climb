import SwiftUI

struct RouteCard: View {
    let route: ClimbingRoute
    let action: () -> Void
    @State private var isPressed = false
    @State private var showShareSheet = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(route.name)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 12))
                            Text(route.difficulty.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(route.difficulty.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(route.difficulty.color.opacity(0.2))
                        )
                    }
                    
                    Spacer()
                    
                    if route.completed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.green)
                    } else {
                        Button(action: {
                            HapticManager.shared.impact(style: .light)
                            showShareSheet = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                HStack(spacing: 20) {
                    InfoPill(icon: "arrow.up.right", value: "\(Int(route.elevation))m", color: .orange)
                    InfoPill(icon: "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath",
                                value: String(format: "%.1f km", route.distance),
                                color: .blue)
                   }
                
                if route.progress > 0 && !route.completed {
                    ProgressView(value: route.progress)
                        .tint(route.difficulty.color)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: route.difficulty.color.opacity(0.3), radius: isPressed ? 5 : 15, x: 0, y: isPressed ? 2 : 8)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
   
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
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: createShareItems())
        }
    }
    
    func createShareItems() -> [Any] {
        let shareText = """
        🏔️ \(route.name)
        
        🎯 Difficulty: \(route.difficulty.rawValue)
        📏 Distance: \(String(format: "%.1f km", route.distance))
        ⛰️ Elevation: \(Int(route.elevation))m
        
        Shared from SUMMIT 🧗‍♂️
        """
        
        return [shareText]
    }
}

struct InfoPill: View {
    let icon: String
    let value: String
    let color:  Color
    
    var body:  some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(value)
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(color.opacity(0.2))
        )
    }
}
