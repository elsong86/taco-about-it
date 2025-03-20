import SwiftUI

struct PlaceTileView: View {
    let place: Place
    @State private var photoURL: URL? = nil
    @State private var isLoadingPhoto = false
    @State private var photoLoadError = false
    
    // Create a computed property for rating display
    private var ratingView: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(place.rating ?? 0) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
            if let rating = place.rating {
                Text(String(format: "%.1f", rating))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            if let reviews = place.userRatingCount {
                Text("(\(reviews))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Photo Section
            photoView
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .clipped()
            
            // Details Section
            VStack(alignment: .leading, spacing: 8) {
                // Name and Address Section
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.displayNameText)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if let address = place.formattedAddress {
                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                // Ratings Section
                if place.rating != nil {
                    ratingView
                }
            }
            
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(generateAccessibilityLabel())
        .task {
            await loadPhoto()
        }
    }
    
    // Photo View
    private var photoView: some View {
        Group {
            if isLoadingPhoto {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            } else if let photoURL = photoURL {
                AsyncImage(url: photoURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
    }
    
    // Placeholder Image
    private var placeholderImage: some View {
        Image(systemName: "fork.knife")
            .font(.largeTitle)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
    
    // Function to load the photo
    private func loadPhoto() async {
        // Only proceed if we have a photo
        guard let photo = place.primaryPhoto else {
            return
        }
        
        isLoadingPhoto = true
        defer { isLoadingPhoto = false }
        
        do {
            photoURL = try await PlacesService.shared.fetchPhotoURL(for: photo, maxWidth: 320, maxHeight: 320)
        } catch {
            photoLoadError = true
            print("Error loading photo: \(error.localizedDescription)")
        }
    }
    
    // Generate accessibility label
    private func generateAccessibilityLabel() -> String {
        var label = place.displayNameText
        if let address = place.formattedAddress {
            label += ", located at \(address)"
        }
        if let rating = place.rating {
            label += ", rated \(String(format: "%.1f", rating)) stars"
        }
        if let reviews = place.userRatingCount {
            label += ", with \(reviews) reviews"
        }
        return label
    }
}

#Preview {
    PlaceTileView(place: Place.mockPlace)
        .padding()
}
