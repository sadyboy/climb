import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var routes: [ClimbingRoute] = []
    @Published var selectedRoute: ClimbingRoute?
    @Published var showingRouteDetail = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadRoutes()
    }
    
    func loadRoutes() {
        routes = ClimbingDataStorage.loadRoutes()
    }
    
    func selectRoute(_ route: ClimbingRoute) {
        selectedRoute = route
        showingRouteDetail = true
    }
    
    func updateRouteProgress(_ route: ClimbingRoute, progress:  Double) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes[index].progress = progress
            if progress >= 1.0 {
                routes[index].completed = true
            }
            ClimbingDataStorage.saveRoutes(routes)
        }
    }
}
