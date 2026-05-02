//
//  MedicineRecordListItem.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftUI

struct MedicineRecordListItem: View {

    var record: MedicineRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(record.name)
                Text("\(record.amountText) \(record.unit.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(record.time)
        }
    }
}
