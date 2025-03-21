import SwiftUI
import Foundation

// A service to handle image caching
class ImageCacheService {
    static let shared = ImageCacheService()
    
    // NSCache for in-memory caching of images
    private let imageCache = NSCache<NSString, UIImage>()
    
    // Debug flag - set to true to enable detailed cache logging
    private let enableLogging = true
    
    private init() {
        // Configure cache limits
        imageCache.countLimit = 100 // Max number of images to keep in memory
        
        // Configure URLCache for disk caching if not already done
        let cacheSizeMemory = 50 * 1024 * 1024 // 50 MB
        let cacheSizeDisk = 100 * 1024 * 1024 // 100 MB
        let urlCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk)
        URLCache.shared = urlCache
        
        if enableLogging {
            logCacheStatus()
        }
    }
    
    private func logCacheStatus() {
        let urlCache = URLCache.shared
        let memoryUsageMB = Double(urlCache.currentMemoryUsage) / (1024 * 1024)
        let diskUsageMB = Double(urlCache.currentDiskUsage) / (1024 * 1024)
        
        print("📦 CACHE STATUS 📦")
        print("Memory cache capacity: \(Double(urlCache.memoryCapacity) / (1024 * 1024)) MB")
        print("Current memory usage: \(memoryUsageMB) MB")
        print("Disk cache capacity: \(Double(urlCache.diskCapacity) / (1024 * 1024)) MB")
        print("Current disk usage: \(diskUsageMB) MB")
    }
    
    // Clear the cache (useful for debugging or low memory situations)
    func clearCache() {
        if enableLogging {
            print("🗑️ CLEARING CACHE 🗑️")
        }
        imageCache.removeAllObjects()
        URLCache.shared.removeAllCachedResponses()
        
        if enableLogging {
            logCacheStatus()
        }
    }
    
    // Load an image from URL with caching
    func loadImage(url: URL) async throws -> UIImage {
        let urlKey = url.absoluteString
        let cacheKey = NSString(string: urlKey)
        
        // Check in-memory cache first
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            if enableLogging {
                print("🏎️ MEMORY CACHE HIT: \(shortenURL(urlKey))")
            }
            return cachedImage
        }
        
        if enableLogging {
            print("🔍 Memory cache miss: \(shortenURL(urlKey))")
        }
        
        // Create a URLRequest that allows caching
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        // Check if we have the response in URLCache (disk cache)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            if enableLogging {
                print("💾 DISK CACHE HIT: \(shortenURL(urlKey))")
            }
            
            if let image = UIImage(data: cachedResponse.data) {
                // Store in memory cache too for faster future access
                imageCache.setObject(image, forKey: cacheKey)
                return image
            }
        }
        
        // If we got here, we need to download from network
        if enableLogging {
            print("📡 DOWNLOADING: \(shortenURL(urlKey))")
        }
        
        // Fetch the image data from network
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Convert data to UIImage
        guard let image = UIImage(data: data), let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "ImageCacheService", code: 100, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data"])
        }
        
        // Store response in URLCache (disk cache)
        if httpResponse.statusCode == 200 {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            
            if enableLogging {
                print("💾 Saved to disk cache: \(shortenURL(urlKey))")
                logCacheStatus()
            }
        }
        
        // Store in memory cache
        imageCache.setObject(image, forKey: cacheKey)
        
        if enableLogging {
            print("🏎️ Saved to memory cache: \(shortenURL(urlKey))")
        }
        
        return image
    }
    
    // Helper method to create Image view with caching
    func cachedImage(url: URL, placeholder: Image = Image(systemName: "fork.knife")) -> some View {
        CachedAsyncImage(url: url, placeholder: placeholder)
    }
    
    // Helper to shorten URLs for logging
    private func shortenURL(_ urlString: String) -> String {
        // Get last path component or a portion of the URL to display
        guard let url = URL(string: urlString) else { return urlString }
        if urlString.count < 40 {
            return urlString
        }
        
        let lastPathComponent = url.lastPathComponent
        let host = url.host ?? ""
        return "\(host)/...\(lastPathComponent.prefix(20))...\(lastPathComponent.count - 20) chars"
    }
}

// A SwiftUI view that uses our caching system
struct CachedAsyncImage: View {
    let url: URL
    let placeholder: Image
    
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var loadError = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            } else if loadError {
                placeholder
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            } else {
                placeholder
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        isLoading = true
        loadError = false
        
        Task {
            do {
                let loadedImage = try await ImageCacheService.shared.loadImage(url: url)
                await MainActor.run {
                    self.image = loadedImage
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.loadError = true
                    self.isLoading = false
                }
            }
        }
    }
}
