//
//  MedicineRecordView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct MedicineRecordView: View {

    @Environment(\.dismiss) private var dismiss
    @State var medicines: [Medicine]

    var modelContext: ModelContext
    @State var record: MedicineRecord
    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    @State private var showAddMedicine = false

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false

        do {
            medicines = try modelContext.fetch(Medicine.fetchDescriptor)
        } catch {
            medicines = []
        }

        if let modelId {
            if let record = modelContext.model(for: modelId) as? MedicineRecord {
                self.record = record
                isNew = false
            } else {
                record = MedicineRecord.new(medicine: nil)
                isNew = true
            }
        } else {
            record = MedicineRecord.new(medicine: nil)
            isNew = true
        }
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(record)
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
                    record.isFavourite.toggle()
                } label: {
                    Image(systemName: record.isFavourite ? "star.fill" : "star")
                        .foregroundStyle(record.isFavourite ? .yellow : .secondary)
                }
            }
            .overlay {
                Text("Medicine Record")
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
                    DatePicker("", selection: $record.timestamp)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Medicine")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    HStack {
                        if medicines.count > 0 {
                            Picker(selection: $record.medicine, label: Text("Medicine")) {
                                ForEach(medicines, id: \.self) { medicine in
                                    Text(medicine.name).tag(medicine)
                                }
                                Divider().tag(Medicine?(nil))
                            }
                            .onAppear {
                                if record.medicine == nil {
                                    record.medicine = medicines.first
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, -8)
                        }
                        Button {
                            showAddMedicine = true
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    TextField("Amount", value: $record.amount, format: .number)
                        .keyboardType(.decimalPad)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Unit")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    Picker("Unit", selection: $record.unit) {
                        ForEach(MedicineUnit.allCases, id: \.self) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                save()
            }, label: {
                if isNew {
                    Text("Add Medicine Record")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Medicine Record")
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
        .sheet(isPresented: $showAddMedicine) {
            MedicineView(modelId: nil, in: modelContext.container) { newMedicine in
                do {
                    medicines = try modelContext.fetch(Medicine.fetchDescriptor)
                } catch {
                    medicines = []
                }

                record.medicine = modelContext.model(for: newMedicine.id) as? Medicine
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview("View Only - New") {
    MedicineRecordView(modelId: nil, in: SampleData.shared.modelContainer)
}
