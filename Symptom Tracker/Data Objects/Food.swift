//
//  Food.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import Foundation
import SwiftData

@Model
class Food {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Food: Equatable {

}

extension Food {
    static func empty() -> Food {
        Food(name: "")
    }

    func isEmpty() -> Bool {
        name.isEmpty
    }

    static var fetchDescriptor: FetchDescriptor<Food> {
        let descriptor = FetchDescriptor<Food>(
            predicate: #Predicate { $0.name.isEmpty == false },
            sortBy: [
                .init(\.name)
            ]
        )
        return descriptor
    }
}

@Model
class FoodRecord {
    var food: Food?
    var timestamp: Date

    init(food: Food?, timestamp: Date) {
        self.food = food
        self.timestamp = timestamp
    }

    var name: String {
        food?.name ?? "Unknown"
    }

    var dateKey: String {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: timestamp)

        return "\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)"
    }

    var time: String {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: timestamp)

        return "\(dateComponents.hour!):\(dateComponents.minute!)"
    }
}

extension FoodRecord {
    static func new(food: Food?) -> FoodRecord {
        FoodRecord(food: food, timestamp: Date())
    }

    func isEmpty() -> Bool {
        food?.isEmpty() ?? true
    }

    static func fetchAllWith(food: Food, modelContext: ModelContext) -> [FoodRecord] {
        let foodId = food.id
        let descriptor = FetchDescriptor<FoodRecord>(
            predicate: #Predicate { $0.food?.id == foodId }
        )

        let foodRecords: [FoodRecord]
        do {
            foodRecords = try modelContext.fetch(descriptor)
        } catch {
            foodRecords = []
        }
        return foodRecords
    }
}
