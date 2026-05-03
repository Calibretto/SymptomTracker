//
//  DrinksView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct DrinksView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Drink.name)]) var drinks: [Drink]

    @State var selectedDrink: Drink? = nil
    @State var drinkToDelete: Drink? = nil
    @State var addDrink: Bool = false
    @State var showDeleteAlert: Bool = false

    func confirmDelete(_ drink: Drink?) {
        drinkToDelete = drink
        showDeleteAlert = true
    }

    func delete(_ drink: Drink?) {
        if let drink {
            try? modelContext.transaction {
                let drinkRecords = DrinkRecord.fetchAllWith(drink: drink, modelContext: modelContext)
                for record in drinkRecords {
                    modelContext.delete(record)
                }
                modelContext.delete(drink)
                try? modelContext.save()
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
                Text("Drinks")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            List {
                ForEach(drinks, id: \.self) { drink in
                    Button {
                        selectedDrink = drink
                    } label: {
                        Text(drink.name)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            confirmDelete(drink)
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                addDrink = true
            }, label: {
                Text("Add Drink")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(item: $selectedDrink) { drink in
            DrinkView(modelId: drink.id, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addDrink) {
            DrinkView(modelId: nil, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .alert("Delete?", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive) {
                delete(drinkToDelete)
            }
            Button("No", role: .cancel) {
                drinkToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this drink?\n\nThis will also delete any drink records of this drink.")
        }
    }
}

#Preview {
    DrinksView()
        .modelContainer(SampleData.shared.modelContainer)
}
