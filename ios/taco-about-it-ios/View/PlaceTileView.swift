import SwiftUI

/// A single-tile view for displaying information about one Place.
struct PlaceTileView: View {
    /// The data model containing place info
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ID: \(place.id)")
                .font(.headline)
            
            // The display name’s text is a convenient computed property on `Place`
            Text("Name: \(place.displayNameText)")
                .font(.subheadline)
            
            // Conditionally show the formatted address if it exists
            if let address = place.formattedAddress {
                Text("Address: \(address)")
                    .font(.footnote)
            }
            
            // Conditionally show rating and reviews if they exist
            if let rating = place.rating {
                Text("Rating: \(rating, specifier: "%.1f")")
                    .font(.footnote)
            }
            
            if let reviewCount = place.userRatingCount {
                Text("Number of Reviews: \(reviewCount)")
                    .font(.footnote)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // ensures left alignment
        .padding() // some padding around the info
        .border(Color.gray, width: 1) // a border to visualize the tile’s dimensions
    }
}

// MARK: - Preview
struct PlaceTileView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide mock data for preview
        PlaceTileView(place: Place(
            id: "123abc",
            displayName: DisplayName(text: "Taco Paradise"),
            formattedAddress: "123 Taco Street, Flavor Town",
            rating: 4.7,
            userRatingCount: 128
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
