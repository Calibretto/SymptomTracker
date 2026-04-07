//
//  SampleBowelMovements.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import Foundation

struct SampleBowelMovements {

    static func bowelMovementRecords() -> [BowelMovementRecord] {
        return [
            BowelMovementRecord(scale: .normal_smooth, timestamp: Date()),
            BowelMovementRecord(scale: .mildDiarrhoea, timestamp: Date()),
            BowelMovementRecord(scale: .severeConstipation, timestamp: Date()),
            BowelMovementRecord(scale: .normal_cracked, timestamp: Date()),
            BowelMovementRecord(scale: .normal_cracked, timestamp: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()),
            BowelMovementRecord(scale: .normal_cracked, timestamp: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()),
        ]
    }
}
