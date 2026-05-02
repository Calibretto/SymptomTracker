//
//  MedicinesView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct MedicinesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Medicine.name)]) var medicines: [Medicine]

    @State var selectedMedicine: Medicine? = nil
    @State var medicineToDelete: Medicine? = nil
    @State var addMedicine: Bool = false
    @State var showDeleteAlert: Bool = false

    func confirmDelete(_ medicine: Medicine?) {
        medicineToDelete = medicine
        showDeleteAlert = true
    }

    func delete(_ medicine: Medicine?) {
        if let medicine {
            try? modelContext.transaction {
                let records = MedicineRecord.fetchAllWith(medicine: medicine, modelContext: modelContext)
                for record in records {
                    modelContext.delete(record)
                }
                modelContext.delete(medicine)
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
                Text("Medicines")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            List {
                ForEach(medicines, id: \.self) { medicine in
                    Button {
                        selectedMedicine = medicine
                    } label: {
                        Text(medicine.name)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            confirmDelete(medicine)
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                addMedicine = true
            }, label: {
                Text("Add Medicine")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(item: $selectedMedicine) { medicine in
            MedicineView(modelId: medicine.id, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addMedicine) {
            MedicineView(modelId: nil, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .alert("Delete?", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive) {
                delete(medicineToDelete)
            }
            Button("No", role: .cancel) {
                medicineToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this medicine?\n\nThis will also delete any medicine records of this medicine.")
        }
    }
}

#Preview {
    MedicinesView()
        .modelContainer(SampleData.shared.modelContainer)
}
