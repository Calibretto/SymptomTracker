//
//  PreviewData.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    private init() {
        let schema = Schema([
            Food.self,
            FoodRecord.self,
            Symptom.self,
            SymptomRecord.self,
            BowelMovementRecord.self,
            Location.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
        )

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContainer.mainContext.autosaveEnabled = false

            insertSampleData()
            try! modelContainer.mainContext.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private func insertSampleData() {
        for foodRecord in SampleFoods.foodRecords() {
            context.insert(foodRecord)
        }

        for symptomRecord in SampleSymptoms.symptomRecords() {
            context.insert(symptomRecord)
        }

        for bowelRecord in SampleBowelMovements.bowelMovementRecords() {
            context.insert(bowelRecord)
        }

        for location in SampleLocations.locations() {
            context.insert(location)
        }
    }
}

extension SampleData: PreviewModifier {
    // make your previewContainer here
    static func makeSharedContext() throws -> ModelContainer {
        return Self.shared.modelContainer
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
 }
