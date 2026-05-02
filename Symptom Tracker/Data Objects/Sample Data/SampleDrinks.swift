//
//  SampleDrinks.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import Foundation

struct SampleDrinks {

    static func drinks() -> [Drink] {
        [
            Drink(name: "Water"),
            Drink(name: "Coffee"),
            Drink(name: "Tea"),
            Drink(name: "Orange Juice"),
        ]
    }

    static func drinkRecords() -> [DrinkRecord] {
        let drinks = drinks()
        return [
            DrinkRecord(drink: drinks[0], timestamp: Date.fromShortString("2026-04-01")),
            DrinkRecord(drink: drinks[1], timestamp: Date.fromShortString("2026-04-01")),
            DrinkRecord(drink: drinks[2], timestamp: Date.fromShortString("2026-04-02")),
            DrinkRecord(drink: drinks[3], timestamp: Date.fromShortString("2026-04-10")),
        ]
    }
}
