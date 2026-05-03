//
//  SampleFoods.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import Foundation

struct SampleFoods {

    static func foods() -> [Food] {
        [
            Food(name: "Food 1", ingredients: [Ingredient(name: "Ingredient 1")]),
            Food(name: "Food 2", ingredients: [Ingredient(name: "Ingredient 2")]),
            Food(name: "Food 3", ingredients: [Ingredient(name: "Ingredient 3")]),
            Food(name: "Food 4", ingredients: [Ingredient(name: "Ingredient 4")]),
            Food(name: "Food 5", ingredients: [Ingredient(name: "Ingredient 5")]),
            Food(name: "Food 6", ingredients: [Ingredient(name: "Ingredient 6")])
        ]
    }

    static func foodRecords() -> [FoodRecord] {
        let foods = foods()
        return [
            FoodRecord(food: foods[0], timestamp: Date.fromShortString("2026-04-01")),
            FoodRecord(food: foods[1], timestamp: Date.fromShortString("2026-04-01")),
            FoodRecord(food: foods[2], timestamp: Date.fromShortString("2026-04-02")),
            FoodRecord(food: foods[3], timestamp: Date.fromShortString("2026-04-02")),
            FoodRecord(food: foods[4], timestamp: Date.fromShortString("2026-04-10")),
            FoodRecord(food: foods[5], timestamp: Date.fromShortString("2026-04-10")),
        ]
    }

}
