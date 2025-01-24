import SwiftUI

struct PlacesListView: View {
    @StateObject private var viewModel: PlacesViewModel
    let location: GeoLocation

    init(viewModel: PlacesViewModel, location: GeoLocation) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.location = location
    }

    var body: some View {
        VStack {
            if viewModel.places.isEmpty {
                Text("No places yet...")
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

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockLocation = GeoLocation(latitude: 37.7749, longitude: -122.4194)

        // Create a mock ContentViewModel with mock data
        let mockContentViewModel = ContentViewModel(useMockData: true)

        // Pass the mock data from ContentViewModel to PlacesViewModel
        let mockPlacesViewModel = PlacesViewModel(prefetchedPlaces: mockContentViewModel.places)

        return PlacesListView(
            viewModel: mockPlacesViewModel, // Use data from ContentViewModel
            location: mockLocation
        )
        .previewLayout(.sizeThatFits)
    }
}
