//
//  Symptom.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 06/04/2026.
//

import Foundation
import SwiftData

@Model
class Symptom {
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension Symptom {
    static func empty() -> Symptom {
        Symptom(name: "")
    }

    func isEmpty() -> Bool {
        name.isEmpty
    }

    static var fetchDescriptor: FetchDescriptor<Symptom> {
        let descriptor = FetchDescriptor<Symptom>(
            predicate: #Predicate { $0.name.isEmpty == false },
            sortBy: [
                .init(\.name)
            ]
        )
        return descriptor
    }
}

@Model
class SymptomRecord {
    var symptom: Symptom?
    var severity: UInt
    var timestamp: Date
    var location: Location?

    var isFavourite: Bool

    init(symptom: Symptom?, severity: UInt, timestamp: Date, location: Location? = nil, isFavourite: Bool = false) {
        self.symptom = symptom
        self.severity = severity
        self.timestamp = timestamp
        self.location = location
        self.isFavourite = isFavourite
    }

    var name: String {
        symptom?.name ?? "Unknown"
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

extension SymptomRecord {
    static func new(symptom: Symptom?, severity: UInt = 5) -> SymptomRecord {
        SymptomRecord(symptom: symptom, severity: severity, timestamp: Date())
    }

    func isEmpty() -> Bool {
        symptom?.isEmpty() ?? true
    }

    static func fetchAllWith(symptom: Symptom, modelContext: ModelContext) -> [SymptomRecord] {
        let symptomId = symptom.id
        let descriptor = FetchDescriptor<SymptomRecord>(
            predicate: #Predicate { $0.symptom?.id == symptomId }
        )

        let symptomRecords: [SymptomRecord]
        do {
            symptomRecords = try modelContext.fetch(descriptor)
        } catch {
            symptomRecords = []
        }
        return symptomRecords
    }

    static func fetchAllWith(location: Location, modelContext: ModelContext) -> [SymptomRecord] {
        let locationId = location.id
        let descriptor = FetchDescriptor<SymptomRecord>(
            predicate: #Predicate { $0.location?.id == locationId }
        )

        let symptomRecords: [SymptomRecord]
        do {
            symptomRecords = try modelContext.fetch(descriptor)
        } catch {
            symptomRecords = []
        }
        return symptomRecords
    }
}
