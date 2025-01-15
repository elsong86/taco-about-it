import SwiftUI

struct ContentView: View {
    @State private var searchText: String = "" // State for search bar input
    @State private var readyToNavigateWithSearch: Bool = false // State to trigger navigation for search bar
    @State private var selectedSearchString: String? // Holds the search string for navigation

    @StateObject private var viewModel = ContentViewModel() // ViewModel for location handling
    @State private var selectedLocation: GeoLocation?
    @State private var readyToNavigateWithLocation: Bool = false // State to trigger navigation for location

    let tacoSpotCharacters: [(character: String, color: Color)] = [
        ("T", Color(hex: "#9F1239")), // Rose 800
        ("A", Color(hex: "#065F46")), // Emerald 800
        ("C", Color(hex: "#D97706")), // Yellow 600
        ("O", Color(hex: "#C2410C")), // Orange 700
        (" ", .clear),               // Space between words
        ("S", Color(hex: "#9F1239")), // Rose 800
        ("P", Color(hex: "#065F46")), // Emerald 800
        ("O", Color(hex: "#D97706")), // Yellow 600
        ("T", Color(hex: "#9F1239"))  // Rose 800
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background Image
                Image("hero")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .clipped()

                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.75),
                        Color.clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)

                Rectangle()
                    .fill(Color.white.opacity(0.65))
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    // Header
                    Header()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                        .edgesIgnoringSafeArea(.top)
                }

                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 80)

                    Text("Anywhere, Anytime")
                        .font(Font.custom("ThirstyRoughReg", size: 20))
                        .foregroundColor(.black)

                    Text("Find Your New")
                        .font(Font.custom("BrothersRegular", size: 30))
                        .foregroundColor(.black)

                    Text("Favorite")
                        .font(Font.custom("BrothersRegular", size: 30))
                        .foregroundColor(.black)

                    HStack(spacing: 0) {
                        ForEach(tacoSpotCharacters, id: \.character) { item in
                            Text(item.character)
                                .foregroundColor(item.color)
                                .font(Font.custom("BrothersRegular", size: 50))
                        }
                    }

                    Text("Share or enter your location to get started")
                        .foregroundColor(.black)

                    Divider()

                    // Share Location Button
                    Button(action: {
                        viewModel.requestLocation()
                        print("Requesting location...")
                    }) {
                        Label("Share Location", systemImage: "location.fill")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)

                    Text("OR")
                        .foregroundColor(.black)

                    // Search Bar
                    SearchBarView(
                        searchText: $searchText,
                        onSearch: {_ in 
                            selectedSearchString = searchText // Set the search string
                            readyToNavigateWithSearch = true // Trigger navigation
                        }
                    )
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .cornerRadius(8)
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
                }
                .padding()
            }
            // Navigation for Share Location
            .onChange(of: viewModel.location) { oldValue, newValue in
                if let location = newValue {
                    selectedLocation = location
                    readyToNavigateWithLocation = true
                }
            }
            .navigationDestination(isPresented: $readyToNavigateWithLocation) {
                if let location = selectedLocation {
                    PlaceholderView(location: location)
                        .onDisappear {
                            readyToNavigateWithLocation = false
                            selectedLocation = nil
                        }
                }
            }
            // Navigation for Search Bar
            .navigationDestination(isPresented: $readyToNavigateWithSearch) {
                if let searchString = selectedSearchString {
                    PlaceholderView(searchString: searchString)
                        .onDisappear {
                            readyToNavigateWithSearch = false
                            selectedSearchString = nil
                        }
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
