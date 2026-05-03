//
//  Food.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import Foundation
import SwiftData

@Model
class Ingredient {
    var name: String
    var isAllergen: Bool

    init(name: String, isAllergen: Bool = false) {
        self.name = name
        self.isAllergen = isAllergen
    }

    static var fetchDescriptor: FetchDescriptor<Ingredient> {
        FetchDescriptor<Ingredient>(sortBy: [.init(\.name)])
    }
}

@Model
class Food {
    var name: String
    var ingredients: [Ingredient]

    init(name: String, ingredients: [Ingredient] = []) {
        self.name = name
        self.ingredients = ingredients
    }
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
    var isFavourite: Bool

    init(food: Food?, timestamp: Date, isFavourite: Bool = false) {
        self.food = food
        self.timestamp = timestamp
        self.isFavourite = isFavourite
    }

    var name: String {
        food?.name ?? "Unknown"
    }

    var dateKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: timestamp)
    }

    var time: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: timestamp)

        return formatter.string(from: dateComponents) ?? ""
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
