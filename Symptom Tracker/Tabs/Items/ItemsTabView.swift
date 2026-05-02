//
//  ItemsTabView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct ItemsTabView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showFoodRecords = false
    @State private var showFoods = false
    @State private var showDrinkRecords = false
    @State private var showDrinks = false
    @State private var showMedicineRecords = false
    @State private var showMedicines = false
    @State private var showSymptomRecords = false
    @State private var showSymptoms = false
    @State private var showLocations = false
    @State private var showBowelRecords = false

    var body: some View {
        List {
            Section("Food") {
                ItemRow(title: "Recorded Food") { showFoodRecords = true }
                ItemRow(title: "Foods") { showFoods = true }
            }
            Section("Drinks") {
                ItemRow(title: "Recorded Drinks") { showDrinkRecords = true }
                ItemRow(title: "Drinks") { showDrinks = true }
            }
            Section("Medicine") {
                ItemRow(title: "Recorded Medicines") { showMedicineRecords = true }
                ItemRow(title: "Medicines") { showMedicines = true }
            }
            Section("Symptoms") {
                ItemRow(title: "Recorded Symptoms") { showSymptomRecords = true }
                ItemRow(title: "Symptoms") { showSymptoms = true }
                ItemRow(title: "Locations") { showLocations = true }
            }
            Section("Bowel Movements") {
                ItemRow(title: "Recorded Bowel Movements") { showBowelRecords = true }
            }
        }
        .sheet(isPresented: $showFoodRecords) {
            FoodRecordsSheetView()
        }
        .sheet(isPresented: $showFoods) {
            FoodsView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showDrinkRecords) {
            DrinkRecordsSheetView()
        }
        .sheet(isPresented: $showDrinks) {
            DrinksView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showMedicineRecords) {
            MedicineRecordsSheetView()
        }
        .sheet(isPresented: $showMedicines) {
            MedicinesView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showSymptomRecords) {
            SymptomRecordsSheetView()
        }
        .sheet(isPresented: $showSymptoms) {
            SymptomsView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showLocations) {
            LocationsView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showBowelRecords) {
            BowelRecordsSheetView()
        }
    }
}

private struct ItemRow: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .foregroundStyle(.primary)
    }
}

private struct FoodRecordsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showAddRecord = false

    var body: some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Recorded Food")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            FoodRecordsView()

            Button { showAddRecord = true } label: {
                Text("Record Food")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.bottom, 24)
        .sheet(isPresented: $showAddRecord) {
            FoodRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

private struct DrinkRecordsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showAddRecord = false

    var body: some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Recorded Drinks")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            DrinkRecordsView()

            Button { showAddRecord = true } label: {
                Text("Record Drink")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.bottom, 24)
        .sheet(isPresented: $showAddRecord) {
            DrinkRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

private struct MedicineRecordsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showAddRecord = false

    var body: some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Recorded Medicines")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            MedicineRecordsView()

            Button { showAddRecord = true } label: {
                Text("Record Medicine")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.bottom, 24)
        .sheet(isPresented: $showAddRecord) {
            MedicineRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

private struct SymptomRecordsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showAddRecord = false

    var body: some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Recorded Symptoms")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            SymptomRecordsView()

            Button { showAddRecord = true } label: {
                Text("Record Symptom")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.bottom, 24)
        .sheet(isPresented: $showAddRecord) {
            SymptomRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

private struct BowelRecordsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showAddRecord = false

    var body: some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Recorded Bowel Movements")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            BowelRecordsView()

            Button { showAddRecord = true } label: {
                Text("Record Bowel Movement")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .padding(.bottom, 24)
        .sheet(isPresented: $showAddRecord) {
            BowelRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

#Preview {
    ItemsTabView()
        .modelContainer(SampleData.shared.modelContainer)
}
