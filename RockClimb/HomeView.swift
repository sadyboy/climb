import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            AnimatedGradientBackground(animate: $animateGradient, colors: [
                Color(red: 0.1, green: 0.15, blue: 0.3),
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.15, green: 0.25, blue: 0.4)
            ])
            
            ScrollView {
                VStack(spacing: 25) {
                    HeaderView(title: "Climbing Routes", subtitle: "Choose your adventure")
                        .padding(.top, 60)
                    
                    ForEach(viewModel.routes) { route in
                        RouteCard(route: route) {
                            viewModel.selectRoute(route)
                        }
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $viewModel.showingRouteDetail) {
            if let route = viewModel.selectedRoute {
                RouteDetailView(route: route, viewModel: viewModel)
            }
        }
        .onAppear {
            animateGradient = true
        }
    }
}
