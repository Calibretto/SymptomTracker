//
//  TimelineView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import SwiftData
import SwiftUI

enum TimelineEntry: Identifiable {
    case food(FoodRecord)
    case drink(DrinkRecord)
    case symptom(SymptomRecord)
    case bowel(BowelMovementRecord)

    var id: ObjectIdentifier {
        switch self {
        case .food(let r): return ObjectIdentifier(r)
        case .drink(let r): return ObjectIdentifier(r)
        case .symptom(let r): return ObjectIdentifier(r)
        case .bowel(let r): return ObjectIdentifier(r)
        }
    }

    var timestamp: Date {
        switch self {
        case .food(let r): return r.timestamp
        case .drink(let r): return r.timestamp
        case .symptom(let r): return r.timestamp
        case .bowel(let r): return r.timestamp
        }
    }

    var dateKey: String {
        switch self {
        case .food(let r): return r.dateKey
        case .drink(let r): return r.dateKey
        case .symptom(let r): return r.dateKey
        case .bowel(let r): return r.dateKey
        }
    }
}

struct TimelineView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FoodRecord.timestamp, order: .reverse) var foodRecords: [FoodRecord]
    @Query(sort: \DrinkRecord.timestamp, order: .reverse) var drinkRecords: [DrinkRecord]
    @Query(sort: \SymptomRecord.timestamp, order: .reverse) var symptomRecords: [SymptomRecord]
    @Query(sort: \BowelMovementRecord.timestamp, order: .reverse) var bowelRecords: [BowelMovementRecord]

    @State private var selectedFoodRecord: FoodRecord?
    @State private var selectedDrinkRecord: DrinkRecord?
    @State private var selectedSymptomRecord: SymptomRecord?
    @State private var selectedBowelRecord: BowelMovementRecord?

    func entriesBySection() -> [String: [TimelineEntry]] {
        var sections: [String: [TimelineEntry]] = [:]

        foodRecords.forEach { sections[$0.dateKey, default: []].append(.food($0)) }
        drinkRecords.forEach { sections[$0.dateKey, default: []].append(.drink($0)) }
        symptomRecords.forEach { sections[$0.dateKey, default: []].append(.symptom($0)) }
        bowelRecords.forEach { sections[$0.dateKey, default: []].append(.bowel($0)) }

        for key in sections.keys {
            sections[key]?.sort { $0.timestamp > $1.timestamp }
        }

        return sections
    }

    func delete(_ entry: TimelineEntry) {
        switch entry {
        case .food(let r): modelContext.delete(r)
        case .drink(let r): modelContext.delete(r)
        case .symptom(let r): modelContext.delete(r)
        case .bowel(let r): modelContext.delete(r)
        }
    }

    var body: some View {
        List {
            let sections = entriesBySection()
            ForEach(sections.keys.sorted(by: >), id: \.self) { key in
                if let entries = sections[key] {
                    Section(header: Text(key)) {
                        ForEach(entries) { entry in
                            Group {
                                switch entry {
                                case .food(let record):
                                    HStack(spacing: 8) {
                                        Image(systemName: "fork.knife.circle")
                                            .foregroundStyle(.secondary)
                                        FoodRecordListItem(foodRecord: record)
                                    }
                                    .onTapGesture { selectedFoodRecord = record }
                                case .drink(let record):
                                    HStack(spacing: 8) {
                                        Image(systemName: "cup.and.saucer")
                                            .foregroundStyle(.secondary)
                                        DrinkRecordListItem(drinkRecord: record)
                                    }
                                    .onTapGesture { selectedDrinkRecord = record }
                                case .symptom(let record):
                                    HStack(spacing: 8) {
                                        Image(systemName: "waveform.path.ecg")
                                            .foregroundStyle(.secondary)
                                        SymptomRecordListItem(record: record)
                                    }
                                    .onTapGesture { selectedSymptomRecord = record }
                                case .bowel(let record):
                                    HStack(spacing: 8) {
                                        Image(systemName: "toilet")
                                            .foregroundStyle(.secondary)
                                        BowelRecordListItem(record: record)
                                    }
                                    .onTapGesture { selectedBowelRecord = record }
                                }
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    delete(entry)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedFoodRecord) { record in
            FoodRecordView(modelId: record.id, in: modelContext.container)
        }
        .sheet(item: $selectedDrinkRecord) { record in
            DrinkRecordView(modelId: record.id, in: modelContext.container)
        }
        .sheet(item: $selectedSymptomRecord) { record in
            SymptomRecordView(modelId: record.id, in: modelContext.container)
        }
        .sheet(item: $selectedBowelRecord) { record in
            BowelRecordView(modelId: record.id, in: modelContext.container)
        }
    }
}

#Preview {
    TimelineView()
        .modelContainer(SampleData.shared.modelContainer)
}
