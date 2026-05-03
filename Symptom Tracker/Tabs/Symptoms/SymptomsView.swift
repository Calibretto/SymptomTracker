//
//  SymptomsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct SymptomsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Symptom.name)]) var symptoms: [Symptom]

    @State var selectedSymptom: Symptom? = nil
    @State var symptomToDelete: Symptom? = nil
    @State var addSymptom: Bool = false
    @State var showDeleteAlert: Bool = false

    func confirmDelete(_ symptom: Symptom?) {
        symptomToDelete = symptom
        showDeleteAlert = true
    }

    func delete(_ symptom: Symptom?) {
        if let symptom {
            try? modelContext.transaction {
                let symptomRecords = SymptomRecord.fetchAllWith(symptom: symptom, modelContext: modelContext)
                for record in symptomRecords {
                    modelContext.delete(record)
                }
                modelContext.delete(symptom)
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
                Text("Symptoms")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            List {
                ForEach(symptoms, id: \.self) { symptom in
                    Button {
                        selectedSymptom = symptom
                    } label: {
                        Text(symptom.name)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            confirmDelete(symptom)
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                addSymptom = true
            }, label: {
                Text("Add Symptom")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(item: $selectedSymptom) { symptom in
            SymptomView(modelId: symptom.id, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addSymptom) {
            SymptomView(modelId: nil, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .alert("Delete?", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive) {
                delete(symptomToDelete)
            }
            Button("No", role: .cancel) {
                symptomToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this symptom?\n\nThis will also delete any symptom records of this symptom.")
        }
    }
}

#Preview {
    SymptomsView()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview("Sheet") {
    @Previewable @State var sheetOpen = false

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Symptoms Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        SymptomsView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
