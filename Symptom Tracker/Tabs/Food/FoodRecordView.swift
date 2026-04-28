//
//  FoodRecordView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 29/03/2026.
//

import SwiftData
import SwiftUI

struct FoodRecordView: View {

    @Environment(\.dismiss) private var dismiss
    @State var foods: [Food]

    var modelContext: ModelContext
    @State var foodRecord: FoodRecord
    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    @State private var showAddFood = false

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false

        do {
            foods = try modelContext.fetch(Food.fetchDescriptor)
        } catch {
            foods = []
        }

        if let modelId {
            if let foodRecord = modelContext.model(for: modelId) as? FoodRecord {
                self.foodRecord = foodRecord
                isNew = false
            } else {
                foodRecord = FoodRecord.new(food: nil)
                isNew = true
            }
        } else {
            foodRecord = FoodRecord.new(food: nil)
            isNew = true
        }
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(foodRecord)
            }
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingAlert = true
        }
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
                Text("Food Record")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    DatePicker("", selection: $foodRecord.timestamp)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Food")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    HStack {
                        if foods.count > 0 {
                            Picker(selection: $foodRecord.food, label: Text("Food")) {
                                ForEach(foods, id: \.self) { food in
                                    Text(food.name).tag(food)
                                }
                                Divider().tag(Food?(nil))
                            }
                            .onAppear {
                                if foodRecord.food == nil {
                                    foodRecord.food = foods.first
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, -8)
                        }
                        Button {
                            showAddFood = true
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                save()
            }, label: {
                if isNew {
                    Text("Add Food Record")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Food Record")
                        .frame(maxWidth: .infinity)
                }
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showAddFood) {
            FoodView(modelId: nil, in: modelContext.container) { newFood in
                do {
                    foods = try modelContext.fetch(Food.fetchDescriptor)
                } catch {
                    foods = []
                }

                foodRecord.food = modelContext.model(for: newFood.id) as? Food
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview("View Only - Existing", traits: .modifier(SampleData.shared)) {
    @Previewable @Query var foodRecords: [FoodRecord]

    FoodRecordView(modelId: foodRecords[0].id, in: SampleData.shared.modelContainer)
}

#Preview("View Only - New") {
    FoodRecordView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - Existing", traits: .modifier(SampleData.shared)) {
    @Previewable @Query var foodRecords: [FoodRecord]
    @Previewable @State var sheetOpen = false

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Food Record Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        FoodRecordView(modelId: foodRecords[0].id, in: SampleData.shared.modelContainer)
            .presentationDetents([.medium])
    }
}
