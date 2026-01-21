import SwiftUI

struct AnimatedMeshGradient: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors:  [
                    Color(red: 0.1, green: 0.15, blue: 0.3),
                    Color(red: 0.15, green: 0.2, blue: 0.35),
                    Color(red:  0.2, green: 0.25, blue: 0.4),
                    Color(red: 0.15, green: 0.2, blue: 0.35)
                ],
                startPoint:  animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
            
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.2),
                    Color.clear
                ],
                center: animate ? .topLeading : .bottomTrailing,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            .blendMode(.softLight)
        }
    }
}
