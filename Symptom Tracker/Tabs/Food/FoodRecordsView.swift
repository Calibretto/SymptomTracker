//
//  FoodRecordsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftData
import SwiftUI

struct FoodRecordsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FoodRecord.timestamp, order: .reverse) var foodRecords: [FoodRecord]

    @State private var selectedRecord: FoodRecord?

    func foodsBySection() -> [String: [FoodRecord]] {
        var foodsBySection: [String: [FoodRecord]] = [:]

        foodRecords.forEach { foodRecord in
            let key = foodRecord.dateKey
            foodsBySection[key, default: []].append(foodRecord)
        }

        return foodsBySection
    }

    func delete(_ foodRecord: FoodRecord?) {
        if let foodRecord {
            modelContext.delete(foodRecord)
            try? modelContext.save()
        }
    }

    var body: some View {
        List {
            let foodsBySection = foodsBySection()
            ForEach(foodsBySection.keys.sorted(), id: \.self) { key in
                if let foodRecords = foodsBySection[key] {
                    Section(header: Text(key)) {
                        ForEach(foodRecords, id: \.self) { foodRecord in
                            FoodRecordListItem(foodRecord: foodRecord)
                            .onTapGesture {
                                selectedRecord = foodRecord
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    delete(foodRecord)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedRecord) { foodRecord in
            FoodRecordView(modelId: foodRecord.id, in: modelContext.container)
        }
    }
}

#Preview {
    FoodRecordsView()
        .modelContainer(SampleData.shared.modelContainer)
}
