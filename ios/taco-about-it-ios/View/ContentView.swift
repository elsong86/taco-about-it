import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @StateObject private var viewModel = ContentViewModel()
    @State private var destination: Destination?
    
    enum Destination: Hashable {
        case location(GeoLocation)
        case search(String)
    }

    let tacoSpotCharacters: [(character: String, color: Color)] = [
        ("T", Color(hex: "#9F1239")), // Rose 800
        ("A", Color(hex: "#065F46")), // Emerald 800
        ("C", Color(hex: "#D97706")), // Yellow 600
        ("O", Color(hex: "#C2410C")), // Orange 700
        ("S", Color(hex: "#9F1239")), // Rose 800
        ("P", Color(hex: "#065F46")), // Emerald 800
        ("O", Color(hex: "#D97706")), // Yellow 600
        ("T", Color(hex: "#9F1239"))  // Rose 800
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                Header()
                    .padding(.bottom, 16) // Spacing below the header

                // Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer()
                            .frame(height: 40) // Reduced height from 80 to 40

                        // Title Section
                        TitleSectionView(tacoSpotCharacters: tacoSpotCharacters)

                        // Instruction Text
                        Text("Share or enter your location to get started")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        Divider()

                        // Action Buttons
                        ActionButtonsView(
                            viewModel: viewModel,
                            searchText: $searchText,
                            destination: $destination
                        )
                    }
                    .padding()
                }
            }
            .background(Color.white) // Optional: Set a background color if desired
            .onChange(of: viewModel.location) { _, newValue in
                if let location = newValue {
                    destination = .location(location)
                }
            }
            .navigationDestination(item: $destination) { destination in
                switch destination {
                case .location(let loc):
                    PlaceholderView(location: loc, searchString: nil, onDisappear: {
                        viewModel.resetLocation()
                    })
                case .search(let query):
                    PlaceholderView(location: nil, searchString: query, onDisappear: {
                        // If you have a separate state for search, reset it here
                        // For example: viewModel.resetSearch()
                    })
                }
            }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
                .environmentObject(mockContentViewModel)
        }
    }

    static var mockContentViewModel: ContentViewModel {
        let viewModel = ContentViewModel()
        // Simulate a mock location for navigation
        viewModel.location = GeoLocation(latitude: 37.7749, longitude: -122.4194)
        return viewModel
    }
}
