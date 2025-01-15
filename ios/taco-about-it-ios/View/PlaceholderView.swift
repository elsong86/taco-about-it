import SwiftUI

struct PlaceholderView: View {
    var location: GeoLocation? = nil
    var searchString: String? = nil

    var body: some View {
        VStack {
            if let location = location {
                Text("Latitude: \(location.latitude)")
                Text("Longitude: \(location.longitude)")
            } else if let searchString = searchString {
                Text("Search Query: \(searchString)")
            } else {
                Text("No data available.")
            }
        }
        .padding()
        .navigationTitle("Results")
    }
}
