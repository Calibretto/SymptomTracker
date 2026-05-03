//
//  IngredientsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 03/05/2026.
//

import SwiftData
import SwiftUI

struct IngredientsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Ingredient.name)]) var ingredients: [Ingredient]

    @State var selectedIngredient: Ingredient? = nil
    @State var ingredientToDelete: Ingredient? = nil
    @State var addIngredient: Bool = false
    @State var showDeleteAlert: Bool = false

    func confirmDelete(_ ingredient: Ingredient?) {
        ingredientToDelete = ingredient
        showDeleteAlert = true
    }

    func delete(_ ingredient: Ingredient?) {
        if let ingredient {
            let foods = (try? modelContext.fetch(FetchDescriptor<Food>())) ?? []
            for food in foods {
                food.ingredients.removeAll { $0.persistentModelID == ingredient.persistentModelID }
            }
            modelContext.delete(ingredient)
            try? modelContext.save()
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
                Text("Ingredients")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            List {
                ForEach(ingredients, id: \.self) { ingredient in
                    Button {
                        selectedIngredient = ingredient
                    } label: {
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            if ingredient.isAllergen {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                    .font(.caption)
                            }
                        }
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            confirmDelete(ingredient)
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                addIngredient = true
            }, label: {
                Text("Add Ingredient")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.bottom, 24)
        .sheet(item: $selectedIngredient) { ingredient in
            IngredientView(modelId: ingredient.id, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addIngredient) {
            IngredientView(modelId: nil, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .alert("Delete?", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive) {
                delete(ingredientToDelete)
            }
            Button("No", role: .cancel) {
                ingredientToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this ingredient?")
        }
    }
}

#Preview {
    IngredientsView()
        .modelContainer(SampleData.shared.modelContainer)
}
