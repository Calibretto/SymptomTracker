//
//  SymptomRecordListItem.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 06/04/2026.
//

import SwiftUI

struct SymptomRecordListItem: View {

    var record: SymptomRecord

    var body: some View {
        HStack {
            Text("\(record.severity)")
                .padding(.trailing, 8)
            Text(record.name)
            Spacer()
            Text(record.time)
        }
    }
}

#Preview {
    let record = SampleSymptoms.symptomRecords().first!
    SymptomRecordListItem(record: record)
}
