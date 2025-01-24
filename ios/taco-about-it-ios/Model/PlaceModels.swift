import Foundation

struct Place: Decodable, Identifiable {
    let id: String
    let displayName: DisplayName
    let formattedAddress: String?
    let rating: Double?
    let userRatingCount: Int?
    
    var displayNameText: String {
        displayName.text
    }
}

struct PlacesRequest: Codable {
    let location: GeoLocation
    let radius: Double
    let maxResults: Int
    let textQuery: String
}

struct PlacesResponse: Decodable {
    let places: [Place]
}

struct DisplayName: Decodable {
    let text: String
}
