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

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

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
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            LazyVGrid(columns: columns) {
                DateTimeRow(title: "Date", value: $record.timestamp)
                SelectSymptomRow(value: $record.symptom, symptoms: $symptoms) {
                    showAddSymptom = true
                }
                SelectSeverityRow(value: $record.severity)
            }

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
