import Foundation

class PlacesService {
    static let shared = PlacesService()
    private let baseURL = "https://your-backend-url.com"

    func fetchPlaces(location: GeoLocation, radius: Double = 1000.0, maxResults: Int = 20, textQuery: String = "tacos") async throws -> [Place] {
        guard let url = URL(string: "\(baseURL)/places") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PlacesRequest(location: location, radius: radius, maxResults: maxResults, textQuery: textQuery)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
        }

        let places = try JSONDecoder().decode([Place].self, from: data)
        return places
    }
}
