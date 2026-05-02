//
//  SampleMedicines.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import Foundation

struct SampleMedicines {

    static func medicines() -> [Medicine] {
        [
            Medicine(name: "Ibuprofen"),
            Medicine(name: "Paracetamol"),
            Medicine(name: "Vitamin C"),
        ]
    }

    static func medicineRecords() -> [MedicineRecord] {
        let medicines = medicines()
        return [
            MedicineRecord(medicine: medicines[0], timestamp: Date.fromShortString("2026-04-01"), amount: 400, unit: .mg),
            MedicineRecord(medicine: medicines[1], timestamp: Date.fromShortString("2026-04-01"), amount: 500, unit: .mg),
            MedicineRecord(medicine: medicines[2], timestamp: Date.fromShortString("2026-04-02"), amount: 1000, unit: .mg),
            MedicineRecord(medicine: medicines[0], timestamp: Date.fromShortString("2026-04-10"), amount: 400, unit: .mg),
        ]
    }
}
