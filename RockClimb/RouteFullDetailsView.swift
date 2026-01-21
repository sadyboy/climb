import SwiftUI

struct RouteFullDetailsView: View {
    let route: ClimbingRoute
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0
    @State private var showShareSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                VStack(spacing: 0) {
                    headerSection
                        .padding(.top, max(geometry.safeAreaInsets.top, 10))
                    
                    segmentedControl
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:   20) {
                            if selectedTab == 0 {
                                overviewSection
                            } else if selectedTab == 1 {
                                weatherSection
                            } else {
                                equipmentSection
                            }
                        }
                        .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 30))
                    }
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: createShareItems())
        }
    }
    
    private var headerSection: some View {
        HStack {
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
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(route.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Full Details")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {
                HapticManager.shared.impact(style: .light)
                showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
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
        .padding(.horizontal, 20)
    }
    
    private var segmentedControl: some View {
        HStack(spacing: 8) {
            TabButton(title: "Overview", icon: "map.fill", isSelected: selectedTab == 0) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = 0
                    HapticManager.shared.selection()
                }
            }
            
            TabButton(title: "Weather", icon: "cloud.sun.fill", isSelected: selectedTab == 1) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = 1
                    HapticManager.shared.selection()
                }
            }
            
            TabButton(title: "Gear", icon: "backpack.fill", isSelected: selectedTab == 2) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = 2
                    HapticManager.shared.selection()
                }
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var overviewSection: some View {
        VStack(spacing:  20) {
            DetailCard(
                title: "Route Description",
                icon: "text.alignleft",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("This climbing route offers an exceptional experience for \(route.difficulty.rawValue.lowercased()) level climbers.The path features stunning views and challenging terrain.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(6)
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    InfoRow(label: "Total Distance", value: String(format: "%.1f km", route.distance))
                    InfoRow(label: "Elevation Gain", value: "\(Int(route.elevation))m")
                    InfoRow(label: "Estimated Time", value: "\(Int(route.distance * 45)) minutes")
                    InfoRow(label: "Difficulty", value: route.difficulty.rawValue)
                }
            }
            
            DetailCard(
                title: "Trail Features",
                icon: "mountain.2.fill",
                color: .green
            ) {
                VStack(spacing: 12) {
                    FeatureRow(icon: "figure.climbing", title: "Technical Climbing", value: "Required")
                    FeatureRow(icon: "drop.fill", title: "Water Access", value: "Limited")
                    FeatureRow(icon: "sun.max.fill", title: "Sun Exposure", value: "High")
                    FeatureRow(icon: "tree.fill", title: "Vegetation", value: "Sparse")
                }
            }
            
            DetailCard(
                title: "Coordinates & Location",
                icon: "location.fill",
                color: .orange
            ) {
                VStack(spacing: 12) {
                    InfoRow(label: "Latitude", value: "37.8651° N")
                    InfoRow(label: "Longitude", value:  "119.5383° W")
                    InfoRow(label: "Region", value: "Mountain Range")
                    
                    MapPreviewBox()
                }
            }
        }
    }
    
    private var weatherSection: some View {
        VStack(spacing: 20) {
            DetailCard(
                title: "Current Conditions",
                icon: "cloud.sun.fill",
                color: .cyan
            ) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("68°F")
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Partly Cloudy")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    HStack(spacing: 20) {
                        WeatherDetail(icon: "wind", label: "Wind", value: "12 mph")
                        WeatherDetail(icon: "humidity.fill", label: "Humidity", value: "45%")
                        WeatherDetail(icon: "eye.fill", label: "Visibility", value: "10 mi")
                    }
                }
            }
            
            DetailCard(
                title: "7-Day Forecast",
                icon: "calendar",
                color: .purple
            ) {
                VStack(spacing: 12) {
                    ForEach(0..<7) { day in
                        ForecastRow(
                            day: getDayName(offset: day),
                            icon:  day % 3 == 0 ? "sun.max.fill" : (day % 3 == 1 ? "cloud.sun.fill" : "cloud.fill"),
                            high: 65 + day * 2,
                            low: 45 + day
                        )
                    }
                }
            }
            
            DetailCard(
                title: "Best Climbing Time",
                icon: "clock.fill",
                color: .green
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Based on weather patterns and conditions, the optimal time for this climb is:")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack {
                        Image(systemName: "sunrise.fill")
                            .foregroundColor(.orange)
                        Text("6:00 AM - 10:00 AM")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius:  12)
                            .fill(Color.orange.opacity(0.2))
                    )
                }
            }
        }
    }
    
    private var equipmentSection: some View {
        VStack(spacing: 20) {
            DetailCard(
                title: "Essential Gear",
                icon: "checkmark.shield.fill",
                color: .green
            ) {
                VStack(spacing: 10) {
                    GearItem(icon: "figure.climbing", name: "Climbing Harness", required: true)
                    GearItem(icon: "figure.walk", name: "Climbing Shoes", required: true)
                    GearItem(icon: "shield.fill", name: "Helmet", required: true)
                    GearItem(icon: "link", name: "Rope (60m)", required: true)
                    GearItem(icon: "arrow.triangle.2.circlepath", name: "Belay Device", required: true)
                }
            }
            
            DetailCard(
                title:  "Recommended Gear",
                icon: "star.fill",
                color: .yellow
            ) {
                VStack(spacing: 10) {
                    GearItem(icon:  "backpack.fill", name: "Backpack (30L)", required: false)
                    GearItem(icon: "drop.fill", name: "Water (2L)", required: false)
                    GearItem(icon: "cross.fill", name: "First Aid Kit", required: false)
                    GearItem(icon:  "flashlight.on.fill", name: "Headlamp", required: false)
                    GearItem(icon:  "phone.fill", name: "GPS Device", required: false)
                }
            }
            
            DetailCard(
                title: "Safety Information",
                icon: "exclamationmark.triangle.fill",
                color: .red
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    SafetyTip(icon: "person.2.fill", text: "Never climb alone - always use the buddy system")
                    SafetyTip(icon: "phone.fill", text: "Ensure cell coverage or carry emergency beacon")
                    SafetyTip(icon: "clock.fill", text: "Start early to avoid afternoon weather changes")
                    SafetyTip(icon: "exclamationmark.triangle.fill", text: "Check weather forecast before departure")
                    SafetyTip(icon:  "cross.case.fill", text: "Know basic first aid and emergency procedures")
                }
            }
        }
    }
    
    func createShareItems() -> [Any] {
        let shareText = """
        🏔️ Check out this climbing route!
        
        📍 \(route.name)
        🎯 Difficulty: \(route.difficulty.rawValue)
        📏 Distance: \(String(format: "%.1f km", route.distance))
        ⛰️ Elevation: \(Int(route.elevation))m
        ⏱️ Duration: ~\(Int(route.distance * 45)) minutes
        
        Shared from SUMMIT - Rock Climbing App
        """
        
        return [shareText]
    }
    
    func getDayName(offset: Int) -> String {
        let days = ["Today", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return days[min(offset, days.count - 1)]
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius:  12)
                    .fill(isSelected ? Color.white.opacity(0.2) : Color.clear)
            )
        }
    }
}

struct DetailCard<Content: View>: View {
    let title: String
    let icon: String
    let color:  Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1.5)
                )
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.green)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

struct MapPreviewBox: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
                        startPoint:  .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
            
            VStack(spacing: 8) {
                Image(systemName: "map.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Tap to view map")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}

struct WeatherDetail: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.cyan)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

struct ForecastRow: View {
    let day: String
    let icon: String
    let high: Int
    let low: Int
    
    var body: some View {
        HStack {
            Text(day)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 50, alignment: .leading)
            
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.yellow)
                .frame(width: 40)
            
            Spacer()
            
            HStack(spacing: 12) {
                Text("\(high)°")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(low)°")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 4)
    }
}

struct GearItem: View {
    let icon: String
    let name:  String
    let required: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: required ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 18))
                .foregroundColor(required ? .green : .white.opacity(0.4))
            
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 24)
            
            Text(name)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            if required {
                Text("Required")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.2))
                    )
            }
        }
        .padding(.vertical, 4)
    }
}

struct SafetyTip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.red)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
    }
}
import SwiftUI
import UIKit

struct ShareSheet:  UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context:  Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        controller.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks
        ]
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
