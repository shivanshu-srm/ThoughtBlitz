import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GameData())
                .colorScheme(.dark)
        }
    }
}
