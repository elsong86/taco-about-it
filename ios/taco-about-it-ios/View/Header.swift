import SwiftUI

struct Header: View {
    let title: [(character: String, color: Color)] = [
        ("T", Color(hex: "#9F1239")), // Rose 800
        ("A", Color(hex: "#065F46")), // Emerald 800
        ("C", Color(hex: "#D97706")), // Yellow 600
        ("O", Color(hex: "#C2410C")), // Orange 700
        ("A", Color(hex: "#9F1239")), // Rose 800
        ("B", Color(hex: "#065F46")), // Emerald 800
        ("O", Color(hex: "#D97706")), // Yellow 600
        ("U", Color(hex: "#C2410C")), // Orange 700
        ("T", Color(hex: "#9F1239")), // Rose 800
        ("I", Color(hex: "#065F46")), // Emerald 800
        ("T", Color(hex: "#D97706"))  // Yellow 600
    ]

    var body: some View {
        HStack {
            // Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 40) // Adjust size as needed

            // Title
            HStack(spacing: 0) {
                ForEach(title, id: \.character) { item in
                    Text(item.character)
                        .foregroundColor(item.color)
                        .font(Font.custom("HustlersRoughDemo", size: 30))
                }
            }

            Spacer() // Push the menu icon to the far right

            // Menu Icon
            Image(systemName: "line.3.horizontal")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24) // Adjust icon size
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.9)) // Apply background with opacity
        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2) // Shadow
        .frame(maxWidth: .infinity) // Stretch to the full width of the screen
    }
}

#Preview {
    Header()
}
