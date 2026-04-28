//
//  Bowels.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import Foundation
import SwiftData

enum BristolScale: UInt, Codable, CaseIterable {
    case unknown = 0
    case severeConstipation = 1
    case mildConstipation = 2
    case normal_cracked = 3
    case normal_smooth = 4
    case mildDiarrhoea = 5
    case severeDiarrhoea = 6

    var name: String {
        switch self {
        case.unknown:
            return "Unknown"
        case .severeConstipation:
            return "Severe Constipation"
        case .mildConstipation:
            return "Mild Constipation"
        case .normal_cracked:
            return "Normal (Cracked)"
        case .normal_smooth:
            return "Normal (Smooth)"
        case .mildDiarrhoea:
            return "Mild Diarrhoea"
        case .severeDiarrhoea:
            return "Severe Diarrhoea"
        }
    }
}

@Model
class BowelMovementRecord {
    var scale: BristolScale
    var timestamp: Date

    init(scale: BristolScale, timestamp: Date) {
        self.scale = scale
        self.timestamp = timestamp
    }

    var name: String {
        scale.name
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

extension BowelMovementRecord {
    static func new(scale: BristolScale = .unknown) -> BowelMovementRecord {
        BowelMovementRecord(scale: scale, timestamp: Date())
    }

    func isEmpty() -> Bool {
        scale == .unknown
    }
}
