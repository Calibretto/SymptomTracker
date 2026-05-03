//
//  AddFromFavouritesView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 03/05/2026.
//

import SwiftData
import SwiftUI

struct AddFromFavouritesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(filter: #Predicate<FoodRecord> { $0.isFavourite },
           sort: \FoodRecord.timestamp, order: .reverse)
    var foodRecords: [FoodRecord]

    @Query(filter: #Predicate<DrinkRecord> { $0.isFavourite },
           sort: \DrinkRecord.timestamp, order: .reverse)
    var drinkRecords: [DrinkRecord]

    @Query(filter: #Predicate<MedicineRecord> { $0.isFavourite },
           sort: \MedicineRecord.timestamp, order: .reverse)
    var medicineRecords: [MedicineRecord]

    @Query(filter: #Predicate<SymptomRecord> { $0.isFavourite },
           sort: \SymptomRecord.timestamp, order: .reverse)
    var symptomRecords: [SymptomRecord]

    @Query(filter: #Predicate<BowelMovementRecord> { $0.isFavourite },
           sort: \BowelMovementRecord.timestamp, order: .reverse)
    var bowelRecords: [BowelMovementRecord]

    var isEmpty: Bool {
        foodRecords.isEmpty && drinkRecords.isEmpty && medicineRecords.isEmpty
            && symptomRecords.isEmpty && bowelRecords.isEmpty
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Add from Favourites")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            if isEmpty {
                Spacer()
                Text("No favourites yet")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    if !foodRecords.isEmpty {
                        Section("Food") {
                            ForEach(foodRecords, id: \.self) { record in
                                AddRow {
                                    FoodRecordListItem(foodRecord: record)
                                } onAdd: {
                                    addFood(record)
                                }
                            }
                        }
                    }
                    if !drinkRecords.isEmpty {
                        Section("Drinks") {
                            ForEach(drinkRecords, id: \.self) { record in
                                AddRow {
                                    DrinkRecordListItem(drinkRecord: record)
                                } onAdd: {
                                    addDrink(record)
                                }
                            }
                        }
                    }
                    if !medicineRecords.isEmpty {
                        Section("Medicine") {
                            ForEach(medicineRecords, id: \.self) { record in
                                AddRow {
                                    MedicineRecordListItem(record: record)
                                } onAdd: {
                                    addMedicine(record)
                                }
                            }
                        }
                    }
                    if !symptomRecords.isEmpty {
                        Section("Symptoms") {
                            ForEach(symptomRecords, id: \.self) { record in
                                AddRow {
                                    SymptomRecordListItem(record: record)
                                } onAdd: {
                                    addSymptom(record)
                                }
                            }
                        }
                    }
                    if !bowelRecords.isEmpty {
                        Section("Bowel Movements") {
                            ForEach(bowelRecords, id: \.self) { record in
                                AddRow {
                                    BowelRecordListItem(record: record)
                                } onAdd: {
                                    addBowel(record)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func addFood(_ record: FoodRecord) {
        modelContext.insert(FoodRecord(food: record.food, timestamp: Date()))
        try? modelContext.save()
    }

    private func addDrink(_ record: DrinkRecord) {
        modelContext.insert(DrinkRecord(drink: record.drink, timestamp: Date()))
        try? modelContext.save()
    }

    private func addMedicine(_ record: MedicineRecord) {
        modelContext.insert(MedicineRecord(medicine: record.medicine, timestamp: Date(), amount: record.amount, unit: record.unit))
        try? modelContext.save()
    }

    private func addSymptom(_ record: SymptomRecord) {
        modelContext.insert(SymptomRecord(symptom: record.symptom, severity: record.severity, timestamp: Date(), location: record.location))
        try? modelContext.save()
    }

    private func addBowel(_ record: BowelMovementRecord) {
        modelContext.insert(BowelMovementRecord(scale: record.scale, timestamp: Date()))
        try? modelContext.save()
    }
}

private struct AddRow<Content: View>: View {
    @ViewBuilder let content: Content
    let onAdd: () -> Void

    var body: some View {
        HStack {
            content
            Button {
                onAdd()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    AddFromFavouritesView()
        .modelContainer(SampleData.shared.modelContainer)
}
