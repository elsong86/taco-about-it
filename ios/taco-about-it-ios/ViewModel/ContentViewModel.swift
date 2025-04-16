import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var location: GeoLocation?
    @Published var places: [Place] = []
    @Published var errorMessage: String?
   
    private let locationManager = LocationManager()
    private let placesService: PlacesServiceProtocol
    
    init(useMockData: Bool = false) {
        self.placesService = useMockData ? MockPlacesService() : PlacesService.shared
        if useMockData {
            self.places = MockData.places
        }
    }
    
    func refreshPlaces() async throws -> [Place] {
        let (location, places) = try await requestLocationAndFetchPlaces(forceRefresh: true)
        return places
    }
   
    func requestLocationAndFetchPlaces(forceRefresh: Bool = false) async throws -> (GeoLocation, [Place]) {
        do {
            let location = try await locationManager.requestLocationAsync()
            let geoLocation = GeoLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )
            self.location = geoLocation
            
            do {
                let fetchedPlaces = try await placesService.fetchPlaces(
                    location: geoLocation,
                    radius: 1000.0,
                    maxResults: 20,
                    textQuery: "tacos",
                    forceRefresh: forceRefresh
                )
                self.places = fetchedPlaces
                return (geoLocation, fetchedPlaces)
            } catch {
                // If we got location but failed to fetch places, still show location
                self.errorMessage = "Could not fetch places: \(error.localizedDescription)"
                return (geoLocation, [])
            }
        } catch let error as LocationError {
            // More specific error handling for location errors
            throw error
        } catch {
            throw LocationError.unknown(error)
        }
    }
   
    func handleSearch(address: String, forceRefresh: Bool = false) async throws -> (GeoLocation, [Place]) {
        let location = try await geocodeAddress(address)
        self.location = location
        let fetchedPlaces = try await placesService.fetchPlaces(
            location: location,
            radius: 1000.0,
            maxResults: 20,
            textQuery: "tacos",
            forceRefresh: forceRefresh
        )
        self.places = fetchedPlaces
        return (location, fetchedPlaces)
    }
   
    func resetLocation() {
        self.location = nil
    }
}

// MARK: - Geocoding Extension
extension ContentViewModel {
    struct GeocodingResponse: Codable {
        let latitude: Double
        let longitude: Double
    }
   
    func geocodeAddress(_ address: String) async throws -> GeoLocation {
        let trimmedAddress = address.trimmingCharacters(in: .whitespaces)
        
        let url = URL(string: "\(PlacesService.shared.baseURL)/geocode")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(PlacesService.shared.apiKey, forHTTPHeaderField: "X-API-Key")
        
        let requestBody = ["address": trimmedAddress]
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTP Error",
                         code: httpResponse.statusCode,
                         userInfo: [NSLocalizedDescriptionKey: String(data: data, encoding: .utf8) ?? "Unknown error"])
        }
        
        let geocodeResponse = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        return GeoLocation(latitude: geocodeResponse.latitude, longitude: geocodeResponse.longitude)
    }
}
