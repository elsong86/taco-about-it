import SwiftUI

struct PlacesListView: View {
    @StateObject private var viewModel: PlacesViewModel
    let location: GeoLocation
    
    init(viewModel: PlacesViewModel, location: GeoLocation) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.location = location
    }

    var body: some View {
        Group {
            if viewModel.places.isEmpty {
                Text("No places found")
                    .foregroundColor(.gray)
            } else {
                List(viewModel.places) { place in
                    NavigationLink(destination: PlaceView(place: place)) {
                        PlaceTileView(place: place)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Nearby Places")
    }
}

#Preview {
    NavigationView {
        PlacesListView(
            viewModel: PlacesViewModel(prefetchedPlaces: [
                Place(
                    id: "1",
                    displayName: DisplayName(text: "Test Taco Place"),
                    formattedAddress: "123 Test St",
                    rating: 4.5,
                    userRatingCount: 100
                )
            ]),
            location: GeoLocation(latitude: 37.7749, longitude: -122.4194)
        )
    }
}
