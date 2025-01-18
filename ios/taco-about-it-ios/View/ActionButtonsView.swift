import SwiftUI

struct ActionButtonsView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Binding var searchText: String
    @Binding var destination: ContentView.Destination?

    var body: some View {
        VStack {
            // Share Location Button
            Button(action: {
                viewModel.requestLocation()
                print("Requesting location...")
            }) {
                Label("Share Location", systemImage: "location.fill")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)

            Text("OR")
                .foregroundColor(.black)
                .padding(.vertical, 8)

            // Search Bar
            SearchBarView(
                searchText: $searchText,
                onSearch: { text in
                    print("Setting navigationTarget to .search with \(searchText)")
                    destination = .search(text)
                }
            )
            .frame(maxWidth: .infinity) // Make search bar fill available width
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
        }
    }
}

#Preview {
    ActionButtonsView(
        viewModel: ContentViewModel(),
        searchText: .constant(""),
        destination: .constant(nil)
    )
}
