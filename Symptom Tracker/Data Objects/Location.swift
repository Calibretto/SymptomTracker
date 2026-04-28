//
//  Location.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import Foundation
import SwiftData

@Model
class Location {
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension Location {
    static func empty() -> Location {
        Location(name: "")
    }

    func isEmpty() -> Bool {
        name.isEmpty
    }

    static var fetchDescriptor: FetchDescriptor<Location> {
        FetchDescriptor<Location>(
            predicate: #Predicate { $0.name.isEmpty == false },
            sortBy: [.init(\.name)]
        )
    }
}
