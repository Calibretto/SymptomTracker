//
//  MedicineRecordsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct MedicineRecordsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \MedicineRecord.timestamp, order: .reverse) var medicineRecords: [MedicineRecord]

    @State private var selectedRecord: MedicineRecord?

    func recordsBySection() -> [String: [MedicineRecord]] {
        var bySection: [String: [MedicineRecord]] = [:]

        medicineRecords.forEach { record in
            bySection[record.dateKey, default: []].append(record)
        }

        return bySection
    }

    func delete(_ record: MedicineRecord?) {
        if let record {
            modelContext.delete(record)
        }
    }

    var body: some View {
        List {
            let bySection = recordsBySection()
            ForEach(bySection.keys.sorted(), id: \.self) { key in
                if let records = bySection[key] {
                    Section(header: Text(key)) {
                        ForEach(records, id: \.self) { record in
                            MedicineRecordListItem(record: record)
                            .onTapGesture {
                                selectedRecord = record
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    delete(record)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedRecord) { record in
            MedicineRecordView(modelId: record.id, in: modelContext.container)
        }
    }
}

#Preview {
    MedicineRecordsView()
        .modelContainer(SampleData.shared.modelContainer)
}
