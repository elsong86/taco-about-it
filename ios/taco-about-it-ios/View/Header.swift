import SwiftUI

struct Header: View {
    let title: [(character: String, color: Color)] = [
        ("T", .tacoRose),
        ("A", .tacoEmerald),
        ("C", .tacoYellow),
        ("O", .tacoOrange),
        ("A", .tacoRose),
        ("B", .tacoEmerald),
        ("O", .tacoYellow),
        ("U", .tacoOrange),
        ("T", .tacoRose),
        ("I", .tacoEmerald),
        ("T", .tacoYellow)
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
                        .font(AppFonts.hustlersDemo30)
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
