//
//  Date+ST.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import Foundation

extension Date {

    static func fromShortString(_ shortString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: shortString) ?? Date()
    }

}
