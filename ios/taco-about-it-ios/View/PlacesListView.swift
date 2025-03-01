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
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.places) { place in
                            NavigationLink(destination: PlaceView(place: place)) {
                                PlaceTileView(place: place)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Nearby Places")
    }
}

#Preview {
    NavigationView {
        PlacesListView(
            viewModel: PlacesViewModel.preview,  
            location: MockData.location
        )
    }
}
