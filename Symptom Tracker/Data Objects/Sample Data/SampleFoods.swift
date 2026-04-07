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
            Food(name: "Food 1"),
            Food(name: "Food 2"),
            Food(name: "Food 3"),
            Food(name: "Food 4"),
            Food(name: "Food 5"),
            Food(name: "Food 6")
        ]
    }

    static func foodRecords() -> [FoodRecord] {
        let foods = foods()
        return [
            FoodRecord(food: foods[0], timestamp: Date()),
            FoodRecord(food: foods[1], timestamp: Date()),
            FoodRecord(food: foods[2], timestamp: Date()),
            FoodRecord(food: foods[3], timestamp: Date()),
            FoodRecord(food: foods[4], timestamp: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()),
            FoodRecord(food: foods[5], timestamp: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()),
        ]
    }

}
