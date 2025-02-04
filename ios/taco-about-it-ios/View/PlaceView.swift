import SwiftUI

struct PlaceView: View {
    let place: Place
    @State private var reviews: [Review] = []
    @State private var averageSentiment: Double = 0.0
    @State private var isLoading = true
    @State private var error: Error?
    
    init(place: Place, previewReviews: [Review]? = nil, previewSentiment: Double? = nil) {
        self.place = place
        if let reviews = previewReviews {
            _reviews = State(initialValue: reviews)
            _averageSentiment = State(initialValue: previewSentiment ?? 0.0)
            _isLoading = State(initialValue: false)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                // Place Details
                placeDetailsSection
                
                // Reviews Section
                VStack {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    } else if let error = error {
                        Text("Error loading reviews: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ReviewsView(reviews: reviews, averageSentiment: averageSentiment)
                            .padding(.top)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadReviews()
        }
    }
    
    private var placeDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.displayName.text)
                .font(.title)
                .bold()
            
            if let address = place.formattedAddress {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let rating = place.rating {
                HStack {
                    Text(String(format: "%.1f", rating))
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    if let count = place.userRatingCount {
                        Text("(\(count))")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
    }
    
    private func loadReviews() async {
        do {
            let reviewResponse = try await PlacesService.shared.fetchReviews(for: place)
            reviews = reviewResponse.reviews
            averageSentiment = reviewResponse.averageSentiment
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

#Preview {
    NavigationView {
        PlaceView(
            place: Place(
                id: "mock-id-1",
                displayName: DisplayName(text: "Tacos El Rey"),
                formattedAddress: "123 Main Street, San Francisco, CA 94110",
                rating: 4.7,
                userRatingCount: 342
            ),
            previewReviews: [
                Review(reviewText: "Best tacos in the Mission! The al pastor is incredible and their salsa verde is perfectly spicy."),
                Review(reviewText: "Great spot for authentic Mexican food. The tortillas are handmade and you can taste the difference."),
                Review(reviewText: "Decent tacos but a bit pricey for the portion size. The carnitas were tender though.")
            ],
            previewSentiment: 8.5
        )
    }
}

// Additional preview states
struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Loading state
            NavigationView {
                PlaceView(
                    place: Place(
                        id: "mock-id-2",
                        displayName: DisplayName(text: "Taqueria Loading"),
                        formattedAddress: "456 Market St, San Francisco, CA 94105",
                        rating: 4.2,
                        userRatingCount: 156
                    )
                )
            }
            .previewDisplayName("Loading State")
            
            // Empty state
            NavigationView {
                PlaceView(
                    place: Place(
                        id: "mock-id-3",
                        displayName: DisplayName(text: "New Taqueria"),
                        formattedAddress: "789 Valencia St, San Francisco, CA 94110",
                        rating: nil,
                        userRatingCount: nil
                    ),
                    previewReviews: [],
                    previewSentiment: 0.0
                )
            }
            .previewDisplayName("No Reviews")
        }
    }
}
