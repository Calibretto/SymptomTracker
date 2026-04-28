//
//  SampleSymptoms.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 06/04/2026.
//

import Foundation

struct SampleSymptoms {

    static func symptoms() -> [Symptom] {
        [
            Symptom(name: "Headache"),
            Symptom(name: "Stomach Pains"),
            Symptom(name: "Dizziness"),
            Symptom(name: "Bloating")
        ]
    }

    static func symptomRecords() -> [SymptomRecord] {
        let symptoms = symptoms()
        return [
            SymptomRecord(symptom: symptoms[0], severity: 5, timestamp: Date.fromShortString("2026-04-01")),
            SymptomRecord(symptom: symptoms[0], severity: 1, timestamp: Date.fromShortString("2026-04-01")),
            SymptomRecord(symptom: symptoms[1], severity: 6, timestamp: Date.fromShortString("2026-04-02")),
            SymptomRecord(symptom: symptoms[2], severity: 8, timestamp: Date.fromShortString("2026-04-02")),
            SymptomRecord(symptom: symptoms[2], severity: 10, timestamp: Date.fromShortString("2026-04-10")),
            SymptomRecord(symptom: symptoms[3], severity: 3, timestamp: Date.fromShortString("2026-04-10")),
        ]
    }
}
