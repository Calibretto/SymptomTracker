//
//  Drinks.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import Foundation
import SwiftData

@Model
class Drink {
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension Drink {
    static func empty() -> Drink {
        Drink(name: "")
    }

    func isEmpty() -> Bool {
        name.isEmpty
    }

    static var fetchDescriptor: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            predicate: #Predicate { $0.name.isEmpty == false },
            sortBy: [.init(\.name)]
        )
    }
}

@Model
class DrinkRecord {
    var drink: Drink?
    var timestamp: Date

    init(drink: Drink?, timestamp: Date) {
        self.drink = drink
        self.timestamp = timestamp
    }

    var name: String {
        drink?.name ?? "Unknown"
    }

    var dateKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
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

extension DrinkRecord {
    static func new(drink: Drink?) -> DrinkRecord {
        DrinkRecord(drink: drink, timestamp: Date())
    }

    func isEmpty() -> Bool {
        drink?.isEmpty() ?? true
    }

    static func fetchAllWith(drink: Drink, modelContext: ModelContext) -> [DrinkRecord] {
        let drinkId = drink.id
        let descriptor = FetchDescriptor<DrinkRecord>(
            predicate: #Predicate { $0.drink?.id == drinkId }
        )

        let drinkRecords: [DrinkRecord]
        do {
            drinkRecords = try modelContext.fetch(descriptor)
        } catch {
            drinkRecords = []
        }
        return drinkRecords
    }
}
