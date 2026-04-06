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

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

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
            } else {
                food = Food.empty()
                isNew = true
            }
        } else {
            food = Food.empty()
            isNew = true
        }

        self.addedAction = addedAction
    }

    func save() {
        do {
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
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            LazyVGrid(columns: columns) {
                TextInputRow(
                    title: "Name",
                    message: "Enter a name...",
                    value: $food.name
                )
            }

            Spacer()
            
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
        .padding(.bottom, 24)
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview("View Only - Existing") {
    @Previewable @Bindable var food: Food = SampleFoods.foods()[0]

    FoodView(modelId: food.id, in: SampleData.shared.modelContainer)
}

#Preview("View Only - New") {
    FoodView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - Existing") {
    @Previewable @State var sheetOpen = false
    @Previewable @Bindable var food: Food = SampleFoods.foods()[0]

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
        FoodView(modelId: food.id, in: SampleData.shared.modelContainer)
            .presentationDetents([.medium])
    }
}
