//
//  FavouritesView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 03/05/2026.
//

import SwiftData
import SwiftUI

struct FavouritesView: View {
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

    @State private var selectedFoodRecord: FoodRecord?
    @State private var selectedDrinkRecord: DrinkRecord?
    @State private var selectedMedicineRecord: MedicineRecord?
    @State private var selectedSymptomRecord: SymptomRecord?
    @State private var selectedBowelRecord: BowelMovementRecord?

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
                Text("Favourites")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            List {
                if !foodRecords.isEmpty {
                    Section("Food") {
                        ForEach(foodRecords, id: \.self) { record in
                            FoodRecordListItem(foodRecord: record)
                                .onTapGesture { selectedFoodRecord = record }
                                .swipeActions {
                                    Button {
                                        record.isFavourite = false
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: "star.slash")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }
                if !drinkRecords.isEmpty {
                    Section("Drinks") {
                        ForEach(drinkRecords, id: \.self) { record in
                            DrinkRecordListItem(drinkRecord: record)
                                .onTapGesture { selectedDrinkRecord = record }
                                .swipeActions {
                                    Button {
                                        record.isFavourite = false
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: "star.slash")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }
                if !medicineRecords.isEmpty {
                    Section("Medicine") {
                        ForEach(medicineRecords, id: \.self) { record in
                            MedicineRecordListItem(record: record)
                                .onTapGesture { selectedMedicineRecord = record }
                                .swipeActions {
                                    Button {
                                        record.isFavourite = false
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: "star.slash")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }
                if !symptomRecords.isEmpty {
                    Section("Symptoms") {
                        ForEach(symptomRecords, id: \.self) { record in
                            SymptomRecordListItem(record: record)
                                .onTapGesture { selectedSymptomRecord = record }
                                .swipeActions {
                                    Button {
                                        record.isFavourite = false
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: "star.slash")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }
                if !bowelRecords.isEmpty {
                    Section("Bowel Movements") {
                        ForEach(bowelRecords, id: \.self) { record in
                            BowelRecordListItem(record: record)
                                .onTapGesture { selectedBowelRecord = record }
                                .swipeActions {
                                    Button {
                                        record.isFavourite = false
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: "star.slash")
                                    }
                                    .tint(.yellow)
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
        .sheet(item: $selectedMedicineRecord) { record in
            MedicineRecordView(modelId: record.id, in: modelContext.container)
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
    FavouritesView()
        .modelContainer(SampleData.shared.modelContainer)
}
