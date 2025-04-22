import SwiftUI

@main
struct taco_about_it_iosApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isSessionInitialized = false
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .task {
                    // Initialize session during splash screen
                    do {
                        _ = try await SessionManager.shared.ensureValidSession()
                        isSessionInitialized = true
                        print("Session initialized successfully")
                    } catch {
                        print("Failed to initialize session: \(error)")
                        // Handle session initialization failure
                        // You might want to show an error or retry
                    }
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                // App moved to background, perform maintenance
                Task {
                    await DiskCacheService.shared.performMaintenance()
                }
            }
        }
    }
}

// Preview
#Preview {
    SplashScreen()
}
