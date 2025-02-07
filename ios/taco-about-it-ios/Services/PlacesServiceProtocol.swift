import Foundation

protocol PlacesServiceProtocol {
    func fetchPlaces(location: GeoLocation, radius: Double, maxResults: Int, textQuery: String) async throws -> [Place]
    func fetchReviews(for place: Place) async throws -> ReviewAnalysisResponse
}
