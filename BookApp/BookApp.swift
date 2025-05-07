import SwiftUI
import SwiftData

@main
struct BookApp: App {
    var body: some Scene {
        WindowGroup {
            BookList().modelContainer(for: [Book.self])
        }
    }
}


