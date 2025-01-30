import Foundation

// Make sure DisplayName is Codable
struct DisplayName: Codable {
    let text: String
}

// Explicitly conform Place to Codable
struct Place: Codable, Identifiable {
    let id: String
    let displayName: DisplayName
    let formattedAddress: String?
    let rating: Double?
    let userRatingCount: Int?
    
    var displayNameText: String {
        displayName.text
    }
    
    // Explicitly define coding keys if needed
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case formattedAddress
        case rating
        case userRatingCount
    }
}

// Make PlacesRequest fully Codable
struct PlacesRequest: Codable {
    let location: GeoLocation
    let radius: Double
    let maxResults: Int
    let textQuery: String
}

// Make PlacesResponse explicitly Codable
struct PlacesResponse: Codable {
    let places: [Place]
    
    // Explicitly define coding keys
    enum CodingKeys: String, CodingKey {
        case places
    }
    
    // Add explicit encode method if needed
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(places, forKey: .places)
    }
    
    // Add explicit init from decoder if needed
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = try container.decode([Place].self, forKey: .places)
    }
    
    // Add regular init
    init(places: [Place]) {
        self.places = places
    }
}
