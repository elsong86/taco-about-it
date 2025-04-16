import SwiftUI

@main
struct taco_about_it_iosApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
