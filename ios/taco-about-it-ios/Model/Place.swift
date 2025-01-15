import Foundation

struct Place: Codable {
    let id: String
    let displayName: String
    let formattedAddress: String
    let location: GeoLocation
    let types: [String]
    let userRatingCount: Int?
    let rating: Double?
}
