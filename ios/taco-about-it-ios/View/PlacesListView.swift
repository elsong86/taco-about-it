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
            viewModel: PlacesViewModel.preview,  
            location: MockData.location
        )
    }
}
