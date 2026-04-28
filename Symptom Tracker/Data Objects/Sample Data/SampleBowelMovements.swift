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
            BowelMovementRecord(scale: .normal_smooth, timestamp: Date.fromShortString("2026-04-01")),
            BowelMovementRecord(scale: .mildDiarrhoea, timestamp: Date.fromShortString("2026-04-01")),
            BowelMovementRecord(scale: .severeConstipation, timestamp: Date.fromShortString("2026-04-02")),
            BowelMovementRecord(scale: .normal_cracked, timestamp: Date.fromShortString("2026-04-02")),
            BowelMovementRecord(scale: .normal_cracked, timestamp: Date.fromShortString("2026-04-10")),
            BowelMovementRecord(scale: .normal_cracked, timestamp: Date.fromShortString("2026-04-10")),
        ]
    }
}
