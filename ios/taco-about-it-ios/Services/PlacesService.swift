import Foundation

class PlacesService: PlacesServiceProtocol {
    static let shared = PlacesService()
    let baseURL = "https://api.tacoaboutit.app"
    private let urlSession: URLSession
    internal let apiKey: String
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.apiKey = ConfigurationManager.shared.getAPIKey()
    }

    func fetchPlaces(location: GeoLocation, radius: Double = 1000.0, maxResults: Int = 20, textQuery: String = "tacos") async throws -> [Place] {
        guard let url = URL(string: "\(baseURL)/places") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")

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
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        
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

extension PlacesService {
    // Cache for storing photo URLs to avoid repeated API calls
    private static let photoURLCache = NSCache<NSString, NSString>()
    
    // Debug flag - set to true to enable detailed URL cache logging
    private static let enableLogging = true
    
    func fetchPhotoURL(for photo: Photo, maxWidth: Int = 400, maxHeight: Int? = nil) async throws -> URL {
        // Create a cache key from the photo name and dimensions
        let dimensionString = maxHeight != nil ? "\(maxWidth)x\(maxHeight!)" : "\(maxWidth)"
        let cacheKey = NSString(string: "\(photo.name)_\(dimensionString)")
        
        // Check if we already have this URL cached
        if let cachedURLString = PlacesService.photoURLCache.object(forKey: cacheKey) {
            if PlacesService.enableLogging {
                print("🔵 URL CACHE HIT: \(shortenPhotoName(photo.name)) -> \(dimensionString)")
            }
            return URL(string: cachedURLString as String)!
        }
        
        if PlacesService.enableLogging {
            print("⚪ URL cache miss: \(shortenPhotoName(photo.name)) -> \(dimensionString)")
        }
        
        // If not cached, fetch from the API
        guard let url = URL(string: "\(baseURL)/photos") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        let photoRequest = PhotoRequest(
            photoName: photo.name,
            maxHeight: maxHeight,
            maxWidth: maxWidth
        )
        
        let encodedBody = try JSONEncoder().encode(photoRequest)
        request.httpBody = encodedBody
        
        if PlacesService.enableLogging {
            print("📡 FETCHING URL from API: \(shortenPhotoName(photo.name))")
        }
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)
        }
        
        let photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: data)
        guard let photoURL = URL(string: photoResponse.url) else {
            throw NSError(domain: "Invalid photo URL", code: 0, userInfo: nil)
        }
        
        // Cache the URL for future requests
        PlacesService.photoURLCache.setObject(NSString(string: photoResponse.url), forKey: cacheKey)
        
        if PlacesService.enableLogging {
            print("🔵 Cached URL: \(shortenPhotoName(photo.name)) → \(shortenURL(photoResponse.url))")
        }
        
        return photoURL
    }
    
    // Helper to shorten photo name for logging
    private func shortenPhotoName(_ photoName: String) -> String {
        let components = photoName.components(separatedBy: "/")
        if components.count > 1 {
            return "..." + components.suffix(2).joined(separator: "/")
        }
        return photoName
    }
    
    // Helper to shorten URLs for logging
    private func shortenURL(_ urlString: String) -> String {
        if urlString.count < 40 {
            return urlString
        }
        
        guard let url = URL(string: urlString) else { return urlString }
        let host = url.host ?? ""
        let query = url.query?.prefix(30) ?? ""
        return "\(host)/...\(query)..."
    }
}
