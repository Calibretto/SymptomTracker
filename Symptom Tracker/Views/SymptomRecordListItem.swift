//
//  SymptomRecordListItem.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 06/04/2026.
//

import SwiftUI

struct SymptomRecordListItem: View {

    var record: SymptomRecord

    private var severityColor: Color {
        let hue = 0.33 * Double(11 - record.severity) / 10.0
        return Color(hue: hue, saturation: 0.85, brightness: 0.85)
    }

    var body: some View {
        HStack {
            Text("\(record.severity)")
                .foregroundStyle(severityColor)
                .fontWeight(.semibold)
                .padding(.trailing, 8)
            VStack(alignment: .leading, spacing: 2) {
                Text(record.name)
                if let locationName = record.location?.name {
                    Text(locationName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if record.isFavourite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            Text(record.time)
        }
    }
}

#Preview {
    let record = SampleSymptoms.symptomRecords().first!
    SymptomRecordListItem(record: record)
}
