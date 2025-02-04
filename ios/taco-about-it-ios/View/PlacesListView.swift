import SwiftUI

struct PlacesListView: View {
    @StateObject private var viewModel: PlacesViewModel
    let location: GeoLocation
    @State private var isLoading = false
    @State private var error: Error?
    
    init(viewModel: PlacesViewModel, location: GeoLocation) {
            _viewModel = StateObject(wrappedValue: viewModel) // Note the underscore prefix
            self.location = location
        }

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = error {
                VStack {
                    Text("Error loading places")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task {
                            await loadPlaces()
                        }
                    }
                    .padding()
                }
            } else if viewModel.places.isEmpty {
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
        .task {
            await loadPlaces()
        }
    }
    
    private func loadPlaces() async {
        isLoading = true
        error = nil
        
        do {
            let places = try await PlacesService.shared.fetchPlaces(location: location)
            viewModel.places = places
        } catch {
            self.error = error
        }
        
        isLoading = false
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
