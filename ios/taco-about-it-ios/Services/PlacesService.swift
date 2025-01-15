import Foundation

class PlacesService {
    static let shared = PlacesService()
    private let baseURL = "https://your-backend-url.com"

    func fetchPlaces(location: GeoLocation, radius: Double = 1000.0, maxResults: Int = 20, textQuery: String = "tacos", completion: @escaping (Result<[Place], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/places") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PlacesRequest(location: location, radius: radius, maxResults: maxResults, textQuery: textQuery)
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                let places = try JSONDecoder().decode([Place].self, from: data)
                completion(.success(places))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
