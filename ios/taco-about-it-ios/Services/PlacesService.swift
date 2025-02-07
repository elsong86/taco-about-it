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
            print("Error: Invalid URL construction - \(baseURL)/places")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PlacesRequest(location: location, radius: radius, maxResults: maxResults, textQuery: textQuery)
        
        do {
            let encodedBody = try JSONEncoder().encode(body)
            request.httpBody = encodedBody
            print("Request URL: \(url)")
            print("Request Body: \(String(data: encodedBody, encoding: .utf8) ?? "Unable to print body")")
        } catch {
            print("Error encoding request body: \(error)")
            throw error
        }

        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Response is not HTTPURLResponse")
                throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                print("Error: Invalid response status code \(httpResponse.statusCode)")
                throw NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)
            }

            do {
                let placesResponse = try JSONDecoder().decode(PlacesResponse.self, from: data)
                return placesResponse.places
            } catch {
                print("Error decoding response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Failed to decode data: \(responseString)")
                }
                throw error
            }
        } catch {
            print("Network error: \(error)")
            throw error
        }
    }

    func fetchReviews(for place: Place) async throws -> ReviewAnalysisResponse {
        guard let url = URL(string: "\(baseURL)/reviews") else {
            print("Error: Invalid URL construction - \(baseURL)/reviews")
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "place_id", value: place.id),
            URLQueryItem(name: "displayName", value: place.displayName.text),
            URLQueryItem(name: "formattedAddress", value: place.formattedAddress ?? "")
        ]
        
        guard let finalUrl = components.url else {
            print("Error: Failed to construct URL with query parameters")
            throw NSError(domain: "Invalid URL Components", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: finalUrl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Request URL: \(finalUrl)")
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Response is not HTTPURLResponse")
                throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                print("Error: Invalid response status code \(httpResponse.statusCode)")
                throw NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)
            }
            
            do {
                return try JSONDecoder().decode(ReviewAnalysisResponse.self, from: data)
            } catch {
                print("Error decoding response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Failed to decode data: \(responseString)")
                }
                throw error
            }
        } catch {
            print("Network error: \(error)")
            throw error
        }
    }
}
