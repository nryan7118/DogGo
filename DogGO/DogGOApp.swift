//
//  DogGOApp.swift
//  DogGO
//
//  Created by Nick Ryan on 8/23/24.
//

import SwiftUI
import SwiftData

@main
struct DogGOApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Dog.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
