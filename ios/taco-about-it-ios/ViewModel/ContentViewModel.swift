import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var location: GeoLocation?
    @Published var places: [Place] = []
    @Published var errorMessage: String?
    
    private let locationManager = LocationManager()
    
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
                self.places = Self.mockPlaces
            }
        }
        
        func requestLocationAndFetchPlaces() async throws -> GeoLocation {
            let location = try await locationManager.requestLocationAsync()
            let geoLocation = GeoLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )
            self.location = geoLocation
            return geoLocation
        }
        
        func fetchPlaces() async {
            guard let location = location else {
                errorMessage = "Location not available"
                return
            }
            
            do {
                let fetchedPlaces = try await PlacesService.shared.fetchPlaces(location: location)
                self.places = fetchedPlaces
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        
        func resetLocation() {
            self.location = nil
        }
    }
