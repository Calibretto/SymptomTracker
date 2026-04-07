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
            SymptomRecord(symptom: symptoms[0], severity: 5, timestamp: Date()),
            SymptomRecord(symptom: symptoms[0], severity: 1, timestamp: Date()),
            SymptomRecord(symptom: symptoms[1], severity: 6, timestamp: Date()),
            SymptomRecord(symptom: symptoms[2], severity: 8, timestamp: Date()),
            SymptomRecord(symptom: symptoms[2], severity: 10, timestamp: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()),
            SymptomRecord(symptom: symptoms[3], severity: 3, timestamp: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()),
        ]
    }
}
