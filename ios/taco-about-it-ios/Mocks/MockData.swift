// MockData.swift
import Foundation

enum MockData {
    static let location = GeoLocation(
        latitude: 37.7749,
        longitude: -122.4194
    )
    
    static let places: [Place] = [
        Place(
            id: "mock-place-1",
            displayName: DisplayName(text: "El Taco Loco"),
            formattedAddress: "123 Mission St, San Francisco, CA 94110",
            rating: 4.8,
            userRatingCount: 342
        ),
        Place(
            id: "mock-place-2",
            displayName: DisplayName(text: "Taqueria La Mejor"),
            formattedAddress: "456 Valencia St, San Francisco, CA 94103",
            rating: 4.5,
            userRatingCount: 256
        ),
        Place(
            id: "mock-place-3",
            displayName: DisplayName(text: "Tacos El Rey"),
            formattedAddress: "789 24th St, San Francisco, CA 94110",
            rating: 4.9,
            userRatingCount: 512
        ),
        Place(
            id: "mock-place-4",
            displayName: DisplayName(text: "La Taqueria"),
            formattedAddress: "2889 Mission St, San Francisco, CA 94110",
            rating: 4.7,
            userRatingCount: 423
        ),
        Place(
            id: "mock-place-5",
            displayName: DisplayName(text: "El Farolito"),
            formattedAddress: "2779 Mission St, San Francisco, CA 94110",
            rating: 4.6,
            userRatingCount: 678
        )
    ]
    
    static let reviews: [Review] = [
        Review(reviewText: "Best tacos in the Mission! The al pastor is incredible and their salsa verde is perfectly spicy. The tortillas are always fresh and handmade."),
        Review(reviewText: "Great authentic Mexican food. You can really taste the difference with their homemade tortillas. The carnitas are tender and flavorful."),
        Review(reviewText: "Amazing spot for late night tacos. Their horchata is the perfect balance of sweet and creamy. Prices are reasonable for the quality."),
        Review(reviewText: "The carne asada is cooked to perfection. Service can be a bit slow during peak hours but the food is worth the wait."),
        Review(reviewText: "Their fish tacos are surprisingly good! The batter is light and crispy, and the chipotle crema adds the perfect kick.")
    ]
    
    static let reviewResponses: [String: ReviewAnalysisResponse] = Dictionary(
        uniqueKeysWithValues: places.map { place in
            (
                place.id,
                ReviewAnalysisResponse(
                    averageSentiment: Double.random(in: 7.0...9.5),
                    reviews: Array(reviews.shuffled().prefix(3)),
                    source: "Mock Data"
                )
            )
        }
    )
}

// MARK: - Preview Helpers
extension Place {
    static var mockPlace: Place {
        MockData.places[0]
    }
    
    static var mockPlaces: [Place] {
        MockData.places
    }
}

extension Review {
    static var mockReview: Review {
        MockData.reviews[0]
    }
    
    static var mockReviews: [Review] {
        MockData.reviews
    }
}

extension ReviewAnalysisResponse {
    static var mockResponse: ReviewAnalysisResponse {
        MockData.reviewResponses[MockData.places[0].id]!
    }
}

// MARK: - Mock Services
class MockPlacesService: PlacesServiceProtocol {
    func fetchPlaces(location: GeoLocation, radius: Double = 1000.0, maxResults: Int = 20, textQuery: String = "tacos") async throws -> [Place] {
        return MockData.places
    }
    
    func fetchReviews(for place: Place) async throws -> ReviewAnalysisResponse {
        return MockData.reviewResponses[place.id] ?? ReviewAnalysisResponse(
            averageSentiment: 8.5,
            reviews: Array(MockData.reviews.prefix(3)),
            source: "Mock Data"
        )
    }
}

// MARK: - Preview Content Helpers
extension ContentViewModel {
    static var preview: ContentViewModel {
        let viewModel = ContentViewModel(useMockData: true)
        viewModel.location = MockData.location
        viewModel.places = MockData.places
        return viewModel
    }
}

extension PlacesViewModel {
    static var preview: PlacesViewModel {
        PlacesViewModel(prefetchedPlaces: MockData.places)
    }
}
