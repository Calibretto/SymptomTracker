//
//  SymptomRecordView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 06/04/2026.
//

import SwiftData
import SwiftUI

struct SymptomRecordView: View {

    @Environment(\.dismiss) private var dismiss
    @State var symptoms: [Symptom]

    var modelContext: ModelContext
    @State var record: SymptomRecord
    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    @State private var showAddSymptom = false

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false

        do {
            symptoms = try modelContext.fetch(Symptom.fetchDescriptor)
        } catch {
            symptoms = []
        }

        if let modelId {
            if let record = modelContext.model(for: modelId) as? SymptomRecord {
                self.record = record
                isNew = false
            } else {
                record = SymptomRecord.new(symptom: nil)
                isNew = true
            }
        } else {
            record = SymptomRecord.new(symptom: nil)
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
            }
            .overlay {
                Text("Symptom Record")
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
                    Text("Symptom")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    HStack {
                        if symptoms.count > 0 {
                            Picker(selection: $record.symptom, label: Text("Symptom")) {
                                ForEach(symptoms, id: \.self) { symptom in
                                    Text(symptom.name).tag(symptom)
                                }
                                Divider().tag(Symptom?(nil))
                            }
                            .onAppear {
                                if record.symptom == nil {
                                    record.symptom = symptoms.first
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, -8)
                        }
                        Button {
                            showAddSymptom = true
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Severity")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    Picker(selection: $record.severity, label: Text("Severity")) {
                        ForEach(UInt(1)...UInt(11), id: \.self) { severity in
                            Text("\(severity)").tag(severity)
                        }
                        Divider().tag(UInt(99))
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                save()
            }, label: {
                if isNew {
                    Text("Add Symptom Record")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Symptom Record")
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
        .sheet(isPresented: $showAddSymptom) {
            SymptomView(modelId: nil, in: modelContext.container) { newSymptom in
                do {
                    symptoms = try modelContext.fetch(Symptom.fetchDescriptor)
                } catch {
                    symptoms = []
                }

                record.symptom = modelContext.model(for: newSymptom.id) as? Symptom
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview("View Only - Existing", traits: .modifier(SampleData.shared)) {
    @Previewable @Query var records: [SymptomRecord]

    SymptomRecordView(modelId: records[0].id, in: SampleData.shared.modelContainer)
}

#Preview("View Only - New") {
    SymptomRecordView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - Existing", traits: .modifier(SampleData.shared)) {
    @Previewable @Query var records: [SymptomRecord]
    @Previewable @State var sheetOpen = false

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Food Record Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        SymptomRecordView(modelId: records[0].id, in: SampleData.shared.modelContainer)
            .presentationDetents([.medium])
    }
}
