//
//  FoodRecordListItem.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 29/03/2026.
//

import SwiftUI

struct FoodRecordListItem: View {

    var foodRecord: FoodRecord

    var body: some View {
        HStack {
            Text(foodRecord.name)
            Spacer()
            if foodRecord.isFavourite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            Text(foodRecord.time)
        }
    }
}
