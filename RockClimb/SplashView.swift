import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.45),
                    Color(red:  0.2, green: 0.4, blue: 0.6),
                    Color(red: 0.3, green: 0.5, blue: 0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint:  .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 150)
                        .blur(radius: 10)
                    
                    Image(systemName: "figure.climbing")
                        .font(.system(size: 70))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(red: 0.8, green: 0.9, blue: 1.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(rotationAngle))
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Text("SUMMIT")
                    .font(.system(size: 48, weight:  .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(red: 0.9, green: 0.95, blue: 1.0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(opacity)
                
                Text("Master the Mountains")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses:  false)) {
                rotationAngle = 360
            }
        }
    }
}
