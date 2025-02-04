import SwiftUI

struct PlaceTileView: View {
    let place: Place
    
    // Create a computed property for rating display
    private var ratingView: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(place.rating ?? 0) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
            if let rating = place.rating {
                Text(String(format: "%.1f", rating))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            if let reviews = place.userRatingCount {
                Text("(\(reviews))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Address Section
            VStack(alignment: .leading, spacing: 4) {
                Text(place.displayNameText)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if let address = place.formattedAddress {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            // Ratings Section
            if place.rating != nil {
                ratingView
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(generateAccessibilityLabel())
    }
    
    // Generate accessibility label
    private func generateAccessibilityLabel() -> String {
        var label = place.displayNameText
        if let address = place.formattedAddress {
            label += ", located at \(address)"
        }
        if let rating = place.rating {
            label += ", rated \(String(format: "%.1f", rating)) stars"
        }
        if let reviews = place.userRatingCount {
            label += ", with \(reviews) reviews"
        }
        return label
    }
}

#Preview {
    PlaceTileView(place: Place(
        id: "test-id",
        displayName: DisplayName(text: "Taco Paradise"),
        formattedAddress: "123 Taco Street, Flavor Town, CA",
        rating: 4.5,
        userRatingCount: 128
    ))
    .padding()
}
