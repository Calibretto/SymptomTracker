//
//  SymptomRecordsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 06/04/2026.
//

import SwiftData
import SwiftUI

struct SymptomRecordsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \SymptomRecord.timestamp, order: .reverse) var symptomRecords: [SymptomRecord]

    @State private var selectedRecord: SymptomRecord?

    func symptomsBySection() -> [String: [SymptomRecord]] {
        var symptomsBySection: [String: [SymptomRecord]] = [:]

        symptomRecords.forEach { symptomRecord in
            let key = symptomRecord.dateKey
            symptomsBySection[key, default: []].append(symptomRecord)
        }

        return symptomsBySection
    }

    func delete(_ symptomRecord: SymptomRecord?) {
        if let symptomRecord {
            modelContext.delete(symptomRecord)
        }
    }

    var body: some View {
        List {
            let symptomsBySection = symptomsBySection()
            ForEach(symptomsBySection.keys.sorted(), id: \.self) { key in
                if let symptomRecords = symptomsBySection[key] {
                    Section(header: Text(key)) {
                        ForEach(symptomRecords, id: \.self) { symptomRecord in
                            SymptomRecordListItem(record: symptomRecord)
                            .onTapGesture {
                                selectedRecord = symptomRecord
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    delete(symptomRecord)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedRecord) { record in
            SymptomRecordView(modelId: record.id, in: modelContext.container)
        }
    }
}

#Preview {
    SymptomRecordsView()
        .modelContainer(SampleData.shared.modelContainer)
}
