//
//  BowelRecordsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct BowelRecordsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \BowelMovementRecord.timestamp, order: .reverse) var bowelRecords: [BowelMovementRecord]

    @State private var selectedRecord: BowelMovementRecord?

    func bowelMovementsBySection() -> [String: [BowelMovementRecord]] {
        var bowelMovementsBySection: [String: [BowelMovementRecord]] = [:]

        bowelRecords.forEach { bowelRecord in
            let key = bowelRecord.dateKey
            bowelMovementsBySection[key, default: []].append(bowelRecord)
        }

        return bowelMovementsBySection
    }

    func delete(_ bowelRecord: BowelMovementRecord?) {
        if let bowelRecord {
            modelContext.delete(bowelRecord)
            try? modelContext.save()
        }
    }

    var body: some View {
        List {
            let bowelMovementsBySection = bowelMovementsBySection()
            ForEach(bowelMovementsBySection.keys.sorted(), id: \.self) { key in
                if let bowelRecords = bowelMovementsBySection[key] {
                    Section(header: Text(key)) {
                        ForEach(bowelRecords, id: \.self) { bowelRecord in
                            BowelRecordListItem(record: bowelRecord)
                            .onTapGesture {
                                selectedRecord = bowelRecord
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    delete(bowelRecord)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedRecord) { record in
            BowelRecordView(modelId: record.id, in: modelContext.container)
        }
    }
}

#Preview {
    BowelRecordsView()
        .modelContainer(SampleData.shared.modelContainer)
}
