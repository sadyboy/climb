import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var tabOffsets: [CGFloat]
    
    let tabs = [
        ("house.fill", "Home"),
        ("safari.fill", "Compass"),
        ("person.3.fill", "Team"),
        ("flame.fill", "Challenge"),
        ("gearshape.fill", "Settings")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName:  tabs[index].0)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == index ? .white :  .white.opacity(0.5))
                            .frame(height: 24)
                        
                        Text(tabs[index].1)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(selectedTab == index ? .white :  .white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        ZStack {
                            if selectedTab == index {
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.3, green: 0.5, blue: 0.9),
                                                Color(red: 0.5, green: 0.6, blue: 0.95)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(red: 0.3, green: 0.5, blue: 0.9).opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                        }
                    )
                    .offset(y: tabOffsets[index])
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.95),
                            Color(red:  0.1, green: 0.1, blue: 0.15).opacity(0.95)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y:  10)
        )
    }
}
