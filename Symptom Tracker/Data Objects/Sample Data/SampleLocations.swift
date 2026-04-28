//
//  SampleLocations.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import Foundation

struct SampleLocations {

    static func locations() -> [Location] {
        [
            Location(name: "Abdomen"),
            Location(name: "Chest"),
            Location(name: "Head"),
            Location(name: "Lower Back"),
        ]
    }
}
