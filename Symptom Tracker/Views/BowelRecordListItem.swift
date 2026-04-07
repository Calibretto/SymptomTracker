//
//  BowelRecordListItem.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftUI

struct BowelRecordListItem: View {

    var record: BowelMovementRecord

    var body: some View {
        HStack {
            Text("\(record.scale.rawValue)")
                .padding(.trailing, 8)
            Text(record.name)
            Spacer()
            Text(record.time)
        }
    }
}

#Preview {
    let record = SampleBowelMovements.bowelMovementRecords().first!
    BowelRecordListItem(record: record)
}
