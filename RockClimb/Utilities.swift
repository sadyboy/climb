import SwiftUI

extension Color {
    static let primaryGradientStart = Color(red: 0.3, green: 0.5, blue: 0.9)
    static let primaryGradientEnd = Color(red: 0.5, green: 0.6, blue: 0.95)
    
    static let backgroundDark = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let backgroundMedium = Color(red: 0.15, green: 0.2, blue: 0.35)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.3)
}
import SwiftUI

extension View {
    func adaptiveSize() -> some View {
        self.modifier(AdaptiveSizeModifier())
    }
}

struct AdaptiveSizeModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var scaleFactor: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 375 {
            return 0.9
        } else if screenWidth < 390 {
            return 0.95
        } else {
            return 1.0
        }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scaleFactor)
    }
}
import UIKit

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
