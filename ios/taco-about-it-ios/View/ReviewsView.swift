import SwiftUI

struct ReviewsView: View {
    let reviews: [Review]  // Simple array, not a binding
    let averageSentiment: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Sentiment Score Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Sentiment Score")
                    .font(.headline)
                Text(String(format: "%.1f/10", averageSentiment))
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .padding(.bottom)
            
            // Reviews List
            Text("Reviews")
                .font(.headline)
            
            if reviews.isEmpty {
                Text("No reviews available")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(reviews.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(reviews[index].reviewText)
                                    .font(.body)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// Preview provider
#Preview {
    ReviewsView(
        reviews: [
            Review(reviewText: "Great tacos! Would definitely come back."),
            Review(reviewText: "Decent food but slow service."),
            Review(reviewText: "Best Mexican food in the area!")
        ],
        averageSentiment: 8.5
    )
}
