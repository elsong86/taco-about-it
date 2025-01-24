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

    // Fetch places based on latitude and longitude
    func fetchPlaces(latitude: Double, longitude: Double) async {
        guard let url = URL(string: "http://127.0.0.1:8000/places") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody: [String: Any] = [
            "location": [
                "latitude": latitude,
                "longitude": longitude
            ],
            "radius": 1000,
            "max_results": 20,
            "text_query": "tacos"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Error: Invalid response")
                return
            }

            let decodedResponse = try JSONDecoder().decode(PlacesResponse.self, from: data)
            DispatchQueue.main.async {
                self.places = decodedResponse.places
            }
        } catch {
            print("Error fetching places:", error)
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching places: \(error.localizedDescription)"
            }
        }
    }
}
