import SwiftUI

struct ActionButtonsView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Binding var searchText: String
    @Binding var destination: ContentView.Destination?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    isLoading = true
                    do {
                        let location = try await viewModel.requestLocationAndFetchPlaces()
                        await viewModel.fetchPlaces()
                        destination = .location(location)
                    } catch {
                        viewModel.errorMessage = error.localizedDescription
                    }
                    isLoading = false
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 8)
                    }
                    Label("Share Location", systemImage: "location.fill")
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(isLoading)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
            
            Text("OR")
                .foregroundColor(.black)
                .padding(.vertical, 8)
            
            SearchBarView(
                searchText: $searchText,
                onSearch: { text in
                    destination = .search(text)
                }
            )
            .frame(maxWidth: .infinity)
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
