import Foundation

/// A struct representing a geographic location with latitude and longitude.
struct GeoLocation: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}
