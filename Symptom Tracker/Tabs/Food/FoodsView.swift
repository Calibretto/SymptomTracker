//
//  FoodsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 29/03/2026.
//

import SwiftData
import SwiftUI

struct FoodsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Food.name)]) var foods: [Food]

    @State var selectedFood: Food? = nil
    @State var foodToDelete: Food? = nil
    @State var addFood: Bool = false
    @State var showDeleteAlert: Bool = false

    func confirmDelete(_ food: Food?) {
        foodToDelete = food
        showDeleteAlert = true
    }

    func delete(_ food: Food?) {
        if let food {
            try? modelContext.transaction {
                let foodRecords = FoodRecord.fetchAllWith(food: food, modelContext: modelContext)
                for record in foodRecords {
                    modelContext.delete(record)
                }
                modelContext.delete(food)
            }
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
                Text("Foods")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            List {
                ForEach(foods, id: \.self) { food in
                    Button {
                        selectedFood = food
                    } label: {
                        Text(food.name)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            confirmDelete(food)
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                addFood = true
            }, label: {
                Text("Add Food")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(item: $selectedFood) { food in
            FoodView(modelId: food.id, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addFood) {
            FoodView(modelId: nil, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .alert("Delete?", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive) {
                delete(foodToDelete)
            }
            Button("No", role: .cancel) {
                foodToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this food?\n\nThis will also delete any food records of this food.")
        }
    }
}

#Preview {
    FoodsView()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Sheet") {
    @Previewable @State var sheetOpen = false

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Foods Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        FoodsView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
