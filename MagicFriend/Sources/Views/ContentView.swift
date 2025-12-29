import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Tab 1: Camera (Vision)
            Text("Camera View Placeholder")
                .tabItem {
                    Label("Create", systemImage: "sparkles")
                }
            
            // Tab 2: Chat
            Text("Chat View Placeholder")
                .tabItem {
                    Label("Chat", systemImage: "message.bubble")
                }
            
            // Tab 3: Settings
            Text("Settings Placeholder")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.purple) // Magic Color
    }
}

#Preview {
    ContentView()
}
