//
//  DrinkRecordListItem.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftUI

struct DrinkRecordListItem: View {

    var drinkRecord: DrinkRecord

    var body: some View {
        HStack {
            Text(drinkRecord.name)
            Spacer()
            Text(drinkRecord.time)
        }
    }
}
