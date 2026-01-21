import SwiftUI
import Combine
import CoreLocation

class CompassViewModel: ObservableObject {
    @Published var heading: Double = 0
    @Published var direction: String = "N"
    @Published var altitude: Double = 0
    @Published var coordinates: String = "0.0°, 0.0°"
    
    private var timer: AnyCancellable?
    
    init() {
        startSimulation()
    }
    
    func startSimulation() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateHeading()
            }
    }
    
    private func updateHeading() {
        heading += Double.random(in: -2...2)
        if heading < 0 { heading += 360 }
        if heading >= 360 { heading -= 360 }
        
        direction = getDirection(from: heading)
        altitude += Double.random(in: -5...5)
        if altitude < 0 { altitude = 0 }
    }
    
    private func getDirection(from heading: Double) -> String {
        switch heading {
        case 0..<22.5, 337.5..<360: return "N"
        case 22.5..<67.5: return "NE"
        case 67.5..<112.5: return "E"
        case 112.5..<157.5: return "SE"
        case 157.5..<202.5: return "S"
        case 202.5..<247.5: return "SW"
        case 247.5..<292.5: return "W"
        case 292.5..<337.5: return "NW"
        default:  return "N"
        }
    }
}
