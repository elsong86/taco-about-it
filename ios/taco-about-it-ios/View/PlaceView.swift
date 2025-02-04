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
            VStack(alignment: .leading, spacing: 16) {
                // Place Details
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
                
                // Reviews Section
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = error {
                    Text("Error loading reviews: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ReviewsView(reviews: reviews, averageSentiment: averageSentiment)
                }
            }
        }
        .task {
            await loadReviews()
        }
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

