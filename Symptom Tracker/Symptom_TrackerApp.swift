//
//  Symptom_TrackerApp.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftUI
import SwiftData

@main
struct Symptom_TrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Food.self,
            FoodRecord.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContainer.mainContext.autosaveEnabled = false
            return modelContainer
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
