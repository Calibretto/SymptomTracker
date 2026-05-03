//
//  DrinkRecordView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct DrinkRecordView: View {

    @Environment(\.dismiss) private var dismiss
    @State var drinks: [Drink]

    var modelContext: ModelContext
    @State var drinkRecord: DrinkRecord
    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    @State private var showAddDrink = false

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false

        do {
            drinks = try modelContext.fetch(Drink.fetchDescriptor)
        } catch {
            drinks = []
        }

        if let modelId {
            if let drinkRecord = modelContext.model(for: modelId) as? DrinkRecord {
                self.drinkRecord = drinkRecord
                isNew = false
            } else {
                drinkRecord = DrinkRecord.new(drink: nil)
                isNew = true
            }
        } else {
            drinkRecord = DrinkRecord.new(drink: nil)
            isNew = true
        }
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(drinkRecord)
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
                    drinkRecord.isFavourite.toggle()
                } label: {
                    Image(systemName: drinkRecord.isFavourite ? "star.fill" : "star")
                        .foregroundStyle(drinkRecord.isFavourite ? .yellow : .secondary)
                }
            }
            .overlay {
                Text("Drink Record")
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
                    DatePicker("", selection: $drinkRecord.timestamp)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Drink")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    HStack {
                        if drinks.count > 0 {
                            Picker(selection: $drinkRecord.drink, label: Text("Drink")) {
                                ForEach(drinks, id: \.self) { drink in
                                    Text(drink.name).tag(drink)
                                }
                                Divider().tag(Drink?(nil))
                            }
                            .onAppear {
                                if drinkRecord.drink == nil {
                                    drinkRecord.drink = drinks.first
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, -8)
                        }
                        Button {
                            showAddDrink = true
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
                    Text("Add Drink Record")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Drink Record")
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
        .sheet(isPresented: $showAddDrink) {
            DrinkView(modelId: nil, in: modelContext.container) { newDrink in
                do {
                    drinks = try modelContext.fetch(Drink.fetchDescriptor)
                } catch {
                    drinks = []
                }

                drinkRecord.drink = modelContext.model(for: newDrink.id) as? Drink
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview("View Only - New") {
    DrinkRecordView(modelId: nil, in: SampleData.shared.modelContainer)
}
