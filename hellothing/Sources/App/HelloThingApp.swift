import SwiftUI
// import RevenueCat // Uncomment when pod installed

@main
struct HelloThingApp: App {
    init() {
        print("HelloThing iOS Initializing...")
        // Purchases.configure(withAPIKey: "appl_YOUR_PUBLIC_SDK_KEY")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
