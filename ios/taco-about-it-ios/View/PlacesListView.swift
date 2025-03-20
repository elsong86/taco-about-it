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
                            NavigationLink {
                                PlaceView(place: place)
                            } label: {
                                PlaceTileView(place: place)
                            }
                            .buttonStyle(PlainButtonStyle())
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
