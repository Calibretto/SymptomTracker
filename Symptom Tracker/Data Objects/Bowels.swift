//
//  Bowels.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import Foundation
import SwiftData

enum BristolScale: Int, Codable, CaseIterable {
    case unknown = -1
    case wind = 0
    case severeConstipation = 1
    case mildConstipation = 2
    case normal_cracked = 3
    case normal_smooth = 4
    case lacking_fibre = 5
    case mildDiarrhoea = 6
    case severeDiarrhoea = 7

    var name: String {
        switch self {
        case .unknown:
            return "Unknown"
        case.wind:
            return "Wind"
        case .severeConstipation:
            return "Severe Constipation"
        case .mildConstipation:
            return "Mild Constipation"
        case .normal_cracked:
            return "Normal (Cracked)"
        case .normal_smooth:
            return "Normal (Smooth)"
        case .lacking_fibre:
            return "Lacking Fibre"
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

    var isFavourite: Bool

    init(scale: BristolScale, timestamp: Date, isFavourite: Bool = false) {
        self.scale = scale
        self.timestamp = timestamp
        self.isFavourite = isFavourite
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
