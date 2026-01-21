import SwiftUI
import PhotosUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel:  SettingsViewModel
    @State private var animateGradient = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    init() {
        _viewModel = StateObject(wrappedValue:  SettingsViewModel(profile: UserProfileStorage.load()))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedMeshGradient()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing:  30) {
                        HeaderView(title: "Settings", subtitle: "Customize your profile")
                            .padding(.top, max(geometry.safeAreaInsets.top + 10, 60))
                        
                        profilePhotoSection
                        
                        VStack(spacing: 20) {
                            EnhancedTextField(
                                title: "Name",
                                text:  Binding(
                                    get:  { viewModel.profile.name },
                                    set: { viewModel.updateName($0) }
                                ),
                                icon: "person.fill",
                                placeholder: "Enter your name"
                            )
                            
                            StatsCard(profile: viewModel.profile)
                        }
                        
                        settingsSection
                        
                        appVersionSection
                    }
                    .padding(.horizontal, max(20 * adaptiveScale(geometry.size.width), 16))
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 100, 120))
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                if let imageData = image.jpegData(compressionQuality:  0.7) {
                    viewModel.updatePhoto(imageData)
                    appState.userProfile = viewModel.profile
                    HapticManager.shared.notification(type: .success)
                }
            }
        }
        .onAppear {
            animateGradient = true
            appState.userProfile = viewModel.profile
        }
    }
    
    private var profilePhotoSection: some View {
        Button(action: {
            HapticManager.shared.impact(style: .light)
            showingImagePicker = true
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.3, green: 0.5, blue: 0.9),
                                Color(red:  0.5, green: 0.6, blue: 0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 130, height: 130)
                    .shadow(color: Color(red: 0.3, green: 0.5, blue: 0.9).opacity(0.5), radius: 20)
                
                if let photoData = viewModel.profile.photoData,
                   let uiImage = UIImage(data:  photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 55))
                        .foregroundColor(.white)
                }
                
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 130, height: 130)
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                .offset(x: 45, y: 45)
                .shadow(color: .black.opacity(0.3), radius: 5)
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 16) {
            EnhancedSettingRow(
                icon: "bell.fill",
                title: "Notifications",
                value: "On",
                color: .orange,
                action: {
                    HapticManager.shared.impact(style: .light)
                }
            )
            
            EnhancedSettingRow(
                icon: "moon.fill",
                title: "Dark Mode",
                value: "On",
                color: .purple,
                action: {
                    HapticManager.shared.impact(style: .light)
                }
            )
            
            EnhancedSettingRow(
                icon: "globe",
                title: "Language",
                value: "English",
                color: .blue,
                action: {
                    HapticManager.shared.impact(style: .light)
                }
            )
            
            EnhancedSettingRow(
                icon: "shield.fill",
                title: "Privacy",
                value: "Secure",
                color: .green,
                action: {
                    HapticManager.shared.impact(style: .light)
                }
            )
        }
    }
    
    private var appVersionSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 40))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("SUMMIT")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Text("Version 1.0.0")
                .font(.system(size: 14, weight:  .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 20)
    }
    
    func adaptiveScale(_ width: CGFloat) -> CGFloat {
        return width < 375 ? 0.9 : (width < 390 ? 0.95 : 1.0)
    }
}

struct StatsCard: View {
    let profile: UserProfile
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                AnimatedStatItem(
                    icon: "mountain.2.fill",
                    value: "\(profile.climbingLevel)",
                    label: "Level",
                    color: .blue,
                    delay: 0.0
                )
                
                AnimatedStatItem(
                    icon:  "figure.climbing",
                    value: "\(profile.totalClimbs)",
                    label: "Climbs",
                    color:  .green,
                    delay: 0.1
                )
                
                AnimatedStatItem(
                    icon: "trophy.fill",
                    value: "\(profile.achievements.count)",
                    label: "Awards",
                    color: .yellow,
                    delay: 0.2
                )
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth:  1.5
                        )
                )
        )
    }
}

struct AnimatedStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let delay: Double
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(appear ? 1.0 : 0.5)
        .opacity(appear ?  1.0 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                appear = true
            }
        }
    }
}

struct EnhancedSettingRow: View {
    let icon: String
    let title: String
    let value: String
    let color:  Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.3), color.opacity(0.1)],
                                startPoint:  .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 46, height: 46)
                    
                    Image(systemName:  icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
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
    }
}
