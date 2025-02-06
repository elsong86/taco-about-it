import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
   @Published var location: GeoLocation? {
       willSet {
           print("📍 Location about to change to:", newValue?.latitude ?? 0, newValue?.longitude ?? 0)
       }
       didSet {
           print("📍 Location changed to:", location?.latitude ?? 0, location?.longitude ?? 0)
       }
   }
   @Published var places: [Place] = []
   @Published var errorMessage: String?
   
   private let locationManager = LocationManager()
   
   init(useMockData: Bool = false) {
       if useMockData {
           self.places = Self.mockPlaces
       }
   }
   
   func requestLocationAndFetchPlaces() async throws -> (GeoLocation, [Place]) {
       let location = try await locationManager.requestLocationAsync()
       let geoLocation = GeoLocation(
           latitude: location.latitude,
           longitude: location.longitude
       )
       self.location = geoLocation
       let fetchedPlaces = try await PlacesService.shared.fetchPlaces(location: geoLocation)
       self.places = fetchedPlaces
       return (geoLocation, fetchedPlaces)
   }
   
   func handleSearch(address: String) async throws -> (GeoLocation, [Place]) {
       print("🔍 Starting search flow for address:", address)
       let location = try await geocodeAddress(address)
       print("📌 Setting location and fetching places for:", location)
       self.location = location
       let fetchedPlaces = try await PlacesService.shared.fetchPlaces(location: location)
       self.places = fetchedPlaces
       return (location, fetchedPlaces)
   }
   
   func resetLocation() {
       self.location = nil
   }
   
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
}

// MARK: - Geocoding Extension
extension ContentViewModel {
   struct GeocodingResponse: Codable {
       let latitude: Double
       let longitude: Double
   }
   
   func geocodeAddress(_ address: String) async throws -> GeoLocation {
       print("🌎 Starting geocoding process")
       print("📍 Raw address: '\(address)'")
       
       guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
           print("❌ Failed to encode address")
           throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
       }
       print("📍 Encoded address: '\(encodedAddress)'")
       
       let url = URL(string: "\(PlacesService.shared.baseURL)/geocode")!
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
       let trimmedAddress = address.trimmingCharacters(in: .whitespaces)
       print("📍 Raw address: '\(trimmedAddress)'")

       let requestBody = ["address": trimmedAddress]
       let jsonData = try JSONEncoder().encode(requestBody)
       print("📤 Request body: \(String(data: jsonData, encoding: .utf8) ?? "")")
       request.httpBody = jsonData
       
       let (data, response) = try await URLSession.shared.data(for: request)
       
       if let httpResponse = response as? HTTPURLResponse {
           print("📥 Response status code: \(httpResponse.statusCode)")
           print("📥 Response headers: \(httpResponse.allHeaderFields)")
           print("📥 Response body: \(String(data: data, encoding: .utf8) ?? "")")
           
           if !(200..<300).contains(httpResponse.statusCode) {
               throw NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [
                   NSLocalizedDescriptionKey: String(data: data, encoding: .utf8) ?? "Unknown error"
               ])
           }
       }
       
       let geocodeResponse = try JSONDecoder().decode(GeocodingResponse.self, from: data)
       print("✅ Geocoding successful:", geocodeResponse.latitude, geocodeResponse.longitude)
       return GeoLocation(latitude: geocodeResponse.latitude, longitude: geocodeResponse.longitude)
   }
}
