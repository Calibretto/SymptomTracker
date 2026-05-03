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
            if drinkRecord.isFavourite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            Text(drinkRecord.time)
        }
    }
}
