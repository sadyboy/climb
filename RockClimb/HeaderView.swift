import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.8, green: 0.9, blue: 1.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .scaleEffect(animate ? 1.0 : 0.8)
                .opacity(animate ? 1.0 : 0)
            
            Text(subtitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .opacity(animate ? 1.0 : 0)
                .offset(x: animate ? 0 : -20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animate = true
            }
        }
    }
}
