import SwiftUI

struct PlaceView: View {
    let place: Place
    
    var body: some View {
        VStack {
            Text("Details for \(place.id)")
            Text("Details for \(place.displayNameText)")
            Text("Address: \(place.formattedAddress ?? "No address available")")
            Text("Rating: \(place.rating ?? 0.0, specifier: "%.1f")") // Default to 0.0
            Text("User Ratings: \(place.userRatingCount ?? 0)") // Default to 0
        }
    }
}

#Preview {
    PlaceView(place: Place(
        id: "sample-id",
        displayName: DisplayName(text: "Sample Place"),
        formattedAddress: "1234 Sample Street",
        rating: 4.5,
        userRatingCount: 42
    ))
}
