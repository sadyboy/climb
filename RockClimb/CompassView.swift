import SwiftUI

struct CompassView: View {
    @StateObject private var viewModel = CompassViewModel()
    @State private var animateGradient = false
    @State private var pulseAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 60) {
                        HeaderView(title: "Compass", subtitle:  "Navigate your journey")
                            .padding(.top, max(geometry.safeAreaInsets.top + 10, 60))
                        
                        compassCircle(screenWidth: geometry.size.width)
                        
                        
                        navigationData
                    }
                    .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 50, 120))
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            animateGradient = true
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
    
    private func compassCircle(screenWidth: CGFloat) -> some View {
        let circleSize = min(screenWidth * 0.75, 300)
        
        return ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.05),
                                Color.white.opacity(0.02)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: circleSize + CGFloat(index * 30), height: circleSize + CGFloat(index * 30))
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .opacity(pulseAnimation ? 0.3 : 0.6)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: pulseAnimation
                    )
            }
            
            Circle()
                .stroke(lineWidth: 2)
                .foregroundColor(.white.opacity(0.3))
                .frame(width: circleSize, height: circleSize)
            
            Circle()
                .stroke(lineWidth: 2)
                .foregroundColor(.white.opacity(0.2))
                .frame(width: circleSize * 0.85, height: circleSize * 0.85)
            
            ForEach(["N", "E", "S", "W"], id: \.self) { direction in
                Text(direction)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(direction == "N" ? .red : .white)
                    .offset(y: direction == "N" || direction == "S" ? (direction == "N" ? -(circleSize * 0.45) : (circleSize * 0.45)) : 0)
                    .offset(x: direction == "E" || direction == "W" ? (direction == "E" ? (circleSize * 0.45) : -(circleSize * 0.45)) : 0)
            }
            .rotationEffect(.degrees(-viewModel.heading))
            
            Image(systemName: "location.north.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 0)
            
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Text(viewModel.direction)
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("\(Int(viewModel.heading))°")
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
                .offset(y: circleSize * 0.3)
            }
        }
        .frame(height: circleSize * 1.3)
    }
    
    private var navigationData: some View {
        VStack(spacing: 16) {
            EnhancedDataRow(
                icon: "arrow.up",
                label: "Altitude",
                value: "\(Int(viewModel.altitude))m",
                color: .green
            )
            
            EnhancedDataRow(
                icon: "location.fill",
                label: "Coordinates",
                value: viewModel.coordinates,
                color: .blue
            )
            
            EnhancedDataRow(
                icon: "speedometer",
                label: "Heading",
                value: "\(Int(viewModel.heading))°",
                color: .orange
            )
        }
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
}

struct EnhancedDataRow:  View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    @State private var appear = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 46, height: 46)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1.5)
                )
        )
        .scaleEffect(appear ? 1.0 : 0.8)
        .opacity(appear ?  1.0 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                appear = true
            }
        }
    }
}
