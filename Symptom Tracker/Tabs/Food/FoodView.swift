//
//  FoodView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftData
import SwiftUI

struct FoodView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @Bindable var food: Food
    var addedAction: ((Food) -> Void)?

    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"
    @State private var ingredientNames: [String]
    @State private var newIngredientName = ""

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer,
        addedAction: ((Food) -> Void)? = nil
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        if let modelId {
            if let food = modelContext.model(for: modelId) as? Food {
                self.food = food
                isNew = false
                _ingredientNames = State(initialValue: food.ingredients.map { $0.name }.sorted())
            } else {
                food = Food.empty()
                isNew = true
                _ingredientNames = State(initialValue: [])
            }
        } else {
            food = Food.empty()
            isNew = true
            _ingredientNames = State(initialValue: [])
        }

        self.addedAction = addedAction
    }

    func save() {
        do {
            let existingIngredients = (try? modelContext.fetch(Ingredient.fetchDescriptor)) ?? []
            let existingByName = Dictionary(uniqueKeysWithValues: existingIngredients.map { ($0.name, $0) })

            var newIngredients: [Ingredient] = []
            for name in ingredientNames where !name.isEmpty {
                if let existing = existingByName[name] {
                    newIngredients.append(existing)
                } else {
                    let ingredient = Ingredient(name: name)
                    modelContext.insert(ingredient)
                    newIngredients.append(ingredient)
                }
            }
            food.ingredients = newIngredients

            if isNew {
                modelContext.insert(food)
            }
            try modelContext.save()
            addedAction?(food)
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
                Text("Food")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        TextField("Enter a name...", text: $food.name)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        ForEach(ingredientNames.indices, id: \.self) { index in
                            HStack {
                                Text(ingredientNames[index])
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                Button {
                                    ingredientNames.remove(at: index)
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        HStack {
                            TextField("Add ingredient...", text: $newIngredientName)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Button {
                                let trimmed = newIngredientName.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty {
                                    ingredientNames.append(trimmed)
                                    newIngredientName = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
            }

            Button(action: {
                save()
            }, label: {
                if isNew {
                    Text("Add Food")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Food")
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
    }
}

#Preview("View Only - Existing") {
    let container = SampleData.shared.modelContainer
    let foods = (try? container.mainContext.fetch(Food.fetchDescriptor)) ?? []
    FoodView(modelId: foods.first?.id, in: container)
}

#Preview("View Only - New") {
    FoodView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - Existing") {
    @Previewable @State var sheetOpen = false
    let container = SampleData.shared.modelContainer
    let foods = (try? container.mainContext.fetch(Food.fetchDescriptor)) ?? []

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Food Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        FoodView(modelId: foods.first?.id, in: container)
            .presentationDetents([.medium])
    }
}
