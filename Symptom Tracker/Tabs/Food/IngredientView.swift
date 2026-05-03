//
//  IngredientView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 03/05/2026.
//

import SwiftData
import SwiftUI

struct IngredientView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @Bindable var ingredient: Ingredient
    var addedAction: ((Ingredient) -> Void)?

    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer,
        addedAction: ((Ingredient) -> Void)? = nil
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        if let modelId {
            if let ingredient = modelContext.model(for: modelId) as? Ingredient {
                self.ingredient = ingredient
                isNew = false
            } else {
                ingredient = Ingredient(name: "")
                isNew = true
            }
        } else {
            ingredient = Ingredient(name: "")
            isNew = true
        }
        self.addedAction = addedAction
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(ingredient)
            }
            try modelContext.save()
            addedAction?(ingredient)
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
                Text("Ingredient")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    TextField("Enter a name...", text: $ingredient.name)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Toggle(isOn: $ingredient.isAllergen) {
                    Text("Allergen")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                save()
            }, label: {
                if isNew {
                    Text("Add Ingredient")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Ingredient")
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

#Preview("New") {
    IngredientView(modelId: nil, in: SampleData.shared.modelContainer)
}
