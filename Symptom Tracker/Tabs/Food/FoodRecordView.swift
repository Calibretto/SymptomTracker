//
//  FoodRecordView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 29/03/2026.
//

import SwiftData
import SwiftUI

private struct FoodPickerSheet: View {

    let container: ModelContainer
    let alreadySelectedIds: [PersistentIdentifier]
    let onSelect: (PersistentIdentifier) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var allFoods: [Food] = []
    @State private var showCreateFood = false

    var filtered: [Food] {
        allFoods
            .filter { !alreadySelectedIds.contains($0.persistentModelID) }
            .filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
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
                Text("Add Food")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)

            TextField("Search...", text: $searchText)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(filtered, id: \.self) { food in
                        Button {
                            onSelect(food.persistentModelID)
                            dismiss()
                        } label: {
                            Text(food.name)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                        }
                        Divider()
                    }
                }
            }

            Button {
                showCreateFood = true
            } label: {
                Label("Create New Food", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
            .padding(.vertical, 16)
        }
        .onAppear {
            allFoods = (try? container.mainContext.fetch(Food.fetchDescriptor)) ?? []
        }
        .sheet(isPresented: $showCreateFood) {
            FoodView(modelId: nil, in: container) { newFood in
                allFoods = (try? container.mainContext.fetch(Food.fetchDescriptor)) ?? []
                onSelect(newFood.persistentModelID)
                dismiss()
            }
            .presentationDetents([.large])
        }
    }
}

struct FoodRecordView: View {

    @Environment(\.dismiss) private var dismiss
    @State var foods: [Food]

    var modelContext: ModelContext
    @State var foodRecord: FoodRecord
    private var isNew: Bool

    @State private var selectedFoods: [Food] = []
    @State private var isFavourite: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"
    @State private var showFoodPicker = false
    @State private var showCreateFood = false

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
                _isFavourite = State(initialValue: foodRecord.isFavourite)
            } else {
                foodRecord = FoodRecord.new(food: nil)
                isNew = true
                _isFavourite = State(initialValue: false)
            }
        } else {
            foodRecord = FoodRecord.new(food: nil)
            isNew = true
            _isFavourite = State(initialValue: false)
        }
    }

    func save() {
        do {
            if isNew {
                for food in selectedFoods {
                    let record = FoodRecord(food: food, timestamp: foodRecord.timestamp, isFavourite: isFavourite)
                    modelContext.insert(record)
                }
            } else {
                foodRecord.isFavourite = isFavourite
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
                Button {
                    isFavourite.toggle()
                } label: {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .foregroundStyle(isFavourite ? .yellow : .secondary)
                }
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

                    if isNew {
                        ForEach(selectedFoods, id: \.persistentModelID) { food in
                            HStack {
                                Text(food.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                Button {
                                    selectedFoods.removeAll { $0.persistentModelID == food.persistentModelID }
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        Button {
                            showFoodPicker = true
                        } label: {
                            Label("Add food", systemImage: "plus.circle")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
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
                                showCreateFood = true
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
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
            .disabled(isNew && selectedFoods.isEmpty)
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
        .sheet(isPresented: $showFoodPicker) {
            FoodPickerSheet(
                container: modelContext.container,
                alreadySelectedIds: selectedFoods.map(\.persistentModelID)
            ) { foodId in
                if let food = modelContext.model(for: foodId) as? Food {
                    selectedFoods.append(food)
                }
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showCreateFood) {
            FoodView(modelId: nil, in: modelContext.container) { newFood in
                do {
                    foods = try modelContext.fetch(Food.fetchDescriptor)
                } catch {
                    foods = []
                }
                foodRecord.food = modelContext.model(for: newFood.id) as? Food
            }
            .presentationDetents([.large])
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
