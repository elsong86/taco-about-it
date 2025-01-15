import SwiftUI

class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func fetchPlaces(location: GeoLocation) {
        isLoading = true
        errorMessage = nil

        PlacesService.shared.fetchPlaces(location: location) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let places):
                    self?.places = places
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
