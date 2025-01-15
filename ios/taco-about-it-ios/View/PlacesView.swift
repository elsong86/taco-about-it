import SwiftUI

struct PlacesView: View {
    @StateObject var viewModel = PlacesViewModel()
    let location: GeoLocation

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(viewModel.places, id: \.id) { place in
                    VStack(alignment: .leading) {
                        Text(place.displayName)
                            .font(.headline)
                        Text(place.formattedAddress)
                            .font(.subheadline)
                        if let rating = place.rating {
                            Text("Rating: \(rating, specifier: "%.1f")")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPlaces(location: location)
        }
        .navigationTitle("Taco Spots")
    }
}

