import SwiftUI
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    @Published var location: GeoLocation? // Holds the user's location
    @Published var places: [Place] = [] // Fetched places
    @Published var errorMessage: String? // For error handling

    private let locationManager = LocationManager() // Handles location fetching
    private var cancellables = Set<AnyCancellable>() // For Combine subscriptions

    // Mock data for testing or previews
    static let mockPlaces: [Place] = [
        Place(
            id: "1",
            displayName: DisplayName(text: "Taco Paradise"),
            formattedAddress: "123 Taco Street, Flavor Town",
            rating: 4.7,
            userRatingCount: 128
        ),
        Place(
            id: "2",
            displayName: DisplayName(text: "Burrito Bliss"),
            formattedAddress: "456 Burrito Lane, Spice City",
            rating: 4.5,
            userRatingCount: 200
        ),
        Place(
            id: "3",
            displayName: DisplayName(text: "Nacho Nirvana"),
            formattedAddress: "789 Nacho Avenue, Cheese Town",
            rating: 4.9,
            userRatingCount: 300
        )
    ]

    init(useMockData: Bool = false) {
        if useMockData {
            self.places = Self.mockPlaces // Use mock data
        }

        // Observe location changes and update `location`
        locationManager.$location
            .map { $0.map { GeoLocation(latitude: $0.latitude, longitude: $0.longitude) } }
            .assign(to: &$location)

        // Observe error messages from the location manager
        locationManager.$errorMessage
            .assign(to: &$errorMessage)
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func resetLocation() {
        self.location = nil
    }
    
    func requestLocationAndFetchPlaces() async throws -> GeoLocation {
            // Create a continuation that completes when location is received
            return try await withCheckedThrowingContinuation { continuation in
                var cancellable: AnyCancellable?
                
                cancellable = locationManager.$location
                    .compactMap { $0 }
                    .first()
                    .sink { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    } receiveValue: { locationValue in
                        let geoLocation = GeoLocation(
                            latitude: locationValue.latitude,
                            longitude: locationValue.longitude
                        )
                        continuation.resume(returning: geoLocation)
                        cancellable?.cancel()
                    }
                
                locationManager.requestLocation()
            }
        }
    
    // Fetch places using PlacesService
    func fetchPlaces() async {
        guard let location = location else {
            self.errorMessage = "Location not available."
            return
        }

        do {
            let fetchedPlaces = try await PlacesService.shared.fetchPlaces(location: location)
            self.places = fetchedPlaces
        } catch {
            self.errorMessage = "Failed to fetch places: \(error.localizedDescription)"
        }
    }
}
