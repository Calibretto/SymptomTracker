//
//  DrinkRecordsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct DrinkRecordsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \DrinkRecord.timestamp, order: .reverse) var drinkRecords: [DrinkRecord]

    @State private var selectedRecord: DrinkRecord?

    func drinksBySection() -> [String: [DrinkRecord]] {
        var drinksBySection: [String: [DrinkRecord]] = [:]

        drinkRecords.forEach { drinkRecord in
            let key = drinkRecord.dateKey
            drinksBySection[key, default: []].append(drinkRecord)
        }

        return drinksBySection
    }

    func delete(_ drinkRecord: DrinkRecord?) {
        if let drinkRecord {
            modelContext.delete(drinkRecord)
            try? modelContext.save()
        }
    }

    var body: some View {
        List {
            let drinksBySection = drinksBySection()
            ForEach(drinksBySection.keys.sorted(), id: \.self) { key in
                if let drinkRecords = drinksBySection[key] {
                    Section(header: Text(key)) {
                        ForEach(drinkRecords, id: \.self) { drinkRecord in
                            DrinkRecordListItem(drinkRecord: drinkRecord)
                            .onTapGesture {
                                selectedRecord = drinkRecord
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    delete(drinkRecord)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedRecord) { drinkRecord in
            DrinkRecordView(modelId: drinkRecord.id, in: modelContext.container)
        }
    }
}

#Preview {
    DrinkRecordsView()
        .modelContainer(SampleData.shared.modelContainer)
}
