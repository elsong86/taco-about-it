import SwiftUI

@MainActor
class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var errorMessage: String? = nil

    init(prefetchedPlaces: [Place] = []) {
        self.places = prefetchedPlaces
    }
}
