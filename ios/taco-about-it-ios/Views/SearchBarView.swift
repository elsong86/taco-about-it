import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void

    var body: some View {
        HStack(spacing: 8) { // Adjust spacing between the elements
            // TextField
            TextField("Enter Address", text: $searchText)
                .padding(.horizontal, 8)
                .frame(height: 40)
                .background(Color.white) // Light background for the TextField
                .cornerRadius(8)

            // Search Button
            Button(action: onSearch) {
                Text("Search")
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // Constrain to screen width
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        // Remove the overall white background here
        .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
    }
}



#Preview {
    SearchBarView(
        searchText: .constant("Test Address"),
        onSearch: {
            print("Search triggered")
        }
    )
    .padding()
}
