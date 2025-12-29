import SwiftUI
// import RevenueCat // Uncomment when pod installed

@main
struct MagicFriendApp: App {
    init() {
        print("MagicFriend iOS Initializing...")
        // Purchases.configure(withAPIKey: "appl_YOUR_PUBLIC_SDK_KEY")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
