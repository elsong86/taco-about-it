import Foundation

class PlacesService: PlacesServiceProtocol {
    static let shared = PlacesService()
    let baseURL = "https://api.tacoaboutit.app"
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func fetchPlaces(location: GeoLocation, radius: Double = 1000.0, maxResults: Int = 20, textQuery: String = "tacos") async throws -> [Place] {
        guard let url = URL(string: "\(baseURL)/places") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PlacesRequest(location: location, radius: radius, maxResults: maxResults, textQuery: textQuery)
        
        do {
            let encodedBody = try JSONEncoder().encode(body)
            request.httpBody = encodedBody
        } catch {
            throw error
        }

        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)
            }

            do {
                let placesResponse = try JSONDecoder().decode(PlacesResponse.self, from: data)
                return placesResponse.places
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }

    func fetchReviews(for place: Place) async throws -> ReviewAnalysisResponse {
        guard let url = URL(string: "\(baseURL)/reviews") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "place_id", value: place.id),
            URLQueryItem(name: "displayName", value: place.displayName.text),
            URLQueryItem(name: "formattedAddress", value: place.formattedAddress ?? "")
        ]
        
        guard let finalUrl = components.url else {
            throw NSError(domain: "Invalid URL Components", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: finalUrl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
            }
            

            
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)
            }
            
            do {
                return try JSONDecoder().decode(ReviewAnalysisResponse.self, from: data)
            } catch {
                
                throw error
            }
        } catch {
            throw error
        }
    }
}
