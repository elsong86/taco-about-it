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
        VStack { // Wrap the HStack in a VStack to add padding above
            Spacer()
                .frame(height: 20) // Add space above the content (adjust as needed)
            
            HStack {
                // Logo
                Image("logo")

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
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // Constrain to screen width
        }
        .frame(maxWidth: .infinity) // Ensure the header stretches to the full width
        .padding(.top, 20) // Add padding at the top of the header (for additional space)
    }
}

#Preview {
    Header()
}
