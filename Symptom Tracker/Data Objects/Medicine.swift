//
//  Medicine.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import Foundation
import SwiftData

enum MedicineUnit: String, Codable, CaseIterable {
    case mg = "mg"
    case ml = "ml"
    case tablet = "tablet"
    case unit = "unit"

    var displayName: String { rawValue }
}

@Model
class Medicine {
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension Medicine {
    static func empty() -> Medicine {
        Medicine(name: "")
    }

    func isEmpty() -> Bool {
        name.isEmpty
    }

    static var fetchDescriptor: FetchDescriptor<Medicine> {
        FetchDescriptor<Medicine>(
            predicate: #Predicate { $0.name.isEmpty == false },
            sortBy: [.init(\.name)]
        )
    }
}

@Model
class MedicineRecord {
    var medicine: Medicine?
    var timestamp: Date
    var amount: Double
    var unit: MedicineUnit

    init(medicine: Medicine?, timestamp: Date, amount: Double, unit: MedicineUnit) {
        self.medicine = medicine
        self.timestamp = timestamp
        self.amount = amount
        self.unit = unit
    }

    var name: String {
        medicine?.name ?? "Unknown"
    }

    var amountText: String {
        String(format: amount.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%g", amount)
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

extension MedicineRecord {
    static func new(medicine: Medicine?) -> MedicineRecord {
        MedicineRecord(medicine: medicine, timestamp: Date(), amount: 1, unit: .mg)
    }

    func isEmpty() -> Bool {
        medicine?.isEmpty() ?? true
    }

    static func fetchAllWith(medicine: Medicine, modelContext: ModelContext) -> [MedicineRecord] {
        let medicineId = medicine.id
        let descriptor = FetchDescriptor<MedicineRecord>(
            predicate: #Predicate { $0.medicine?.id == medicineId }
        )

        let records: [MedicineRecord]
        do {
            records = try modelContext.fetch(descriptor)
        } catch {
            records = []
        }
        return records
    }
}
