import SwiftUI

struct ContentView: View {
    @State private var searchText: String = "" // State to manage search text

    // Characters and colors for "TACO SPOT"
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
        ZStack(alignment: .top) { // Ensure alignment is at the top
            // Background Image
            Image("hero")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .clipped()

            // Layer 1: Gradient overlay for larger screens
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.75),
                    Color.clear
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)

            // Layer 2: Semi-transparent white overlay for small screens
            Rectangle()
                .fill(Color.white.opacity(0.65))
                .edgesIgnoringSafeArea(.all)

            // Header pinned at the top
            
            VStack(spacing: 0) {
                Header()
                    .frame(maxWidth: .infinity) // Ensure the header stretches to full width
                    .background(Color.white.opacity(0.9)) // Background for visibility
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2) // Shadow for depth
                    .edgesIgnoringSafeArea(.top) // Extend behind the status bar

            }

            // Hero Content
            VStack(spacing: 16) { // Add spacing between elements for better layout
                Spacer() // Push content down from the top
                    .frame(height: 80) // Ensure space for the header

                // Introductory Text
                Text("Anywhere, Anytime")
                    .font(Font.custom("ThirstyRoughReg", size: 20))
                    .foregroundColor(.black)

                Text("Find Your New")
                    .font(Font.custom("BrothersRegular", size: 30))
                    .foregroundColor(.black)

                Text("Favorite")
                    .font(Font.custom("BrothersRegular", size: 30))
                    .foregroundColor(.black)

                // TACO SPOT with colors
                HStack(spacing: 0) {
                    ForEach(tacoSpotCharacters, id: \.character) { item in
                        Text(item.character)
                            .foregroundColor(item.color)
                            .font(Font.custom("BrothersRegular", size: 50))
                    }
                }

                // Instructions
                Text("Share or enter your location to get started")
                    .foregroundColor(.black)

                Divider()

                // Share Location Button
                Button(action: {
                    print("Location shared!")
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

                // Inline Search Bar
                SearchBarView(
                    searchText: $searchText,
                    onSearch: {
                        print("Searching for: \(searchText)")
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
    }
}

// Preview for ContentView
#Preview {
    ContentView()
}
