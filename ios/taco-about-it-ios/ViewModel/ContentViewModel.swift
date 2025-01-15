import SwiftUI
import Combine
import CoreLocation

class ContentViewModel: ObservableObject {
    @Published var location: GeoLocation? // Updated to GeoLocation
    @Published var errorMessage: String?

    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        locationManager.$location
            .map { $0.map { GeoLocation(latitude: $0.latitude, longitude: $0.longitude) } } // Convert CLLocationCoordinate2D to GeoLocation
            .assign(to: &$location)

        locationManager.$errorMessage
            .assign(to: &$errorMessage)
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
}
