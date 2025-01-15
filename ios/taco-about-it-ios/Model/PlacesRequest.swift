import Foundation

struct PlacesRequest: Codable {
    let location: GeoLocation
    let radius: Double
    let maxResults: Int
    let textQuery: String
}
