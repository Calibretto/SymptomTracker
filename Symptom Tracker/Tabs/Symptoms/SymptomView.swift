//
//  SymptomView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct SymptomView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @Bindable var symptom: Symptom
    var addedAction: ((Symptom) -> Void)?

    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer,
        addedAction: ((Symptom) -> Void)? = nil
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        if let modelId {
            if let symptom = modelContext.model(for: modelId) as? Symptom {
                self.symptom = symptom
                isNew = false
            } else {
                symptom = Symptom.empty()
                isNew = true
            }
        } else {
            symptom = Symptom.empty()
            isNew = true
        }

        self.addedAction = addedAction
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(symptom)
            }
            try modelContext.save()

            addedAction?(symptom)
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
                Text("Symptom")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                TextField("Enter a name...", text: $symptom.name)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                save()
            }, label: {
                if isNew {
                    Text("Add Symptom")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Symptom")
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
    }
}

#Preview("View Only - Existing") {
    @Previewable @Bindable var symptom: Symptom = SampleSymptoms.symptoms()[0]

    SymptomView(modelId: symptom.id, in: SampleData.shared.modelContainer)
}

#Preview("View Only - New") {
    SymptomView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - Existing") {
    @Previewable @State var sheetOpen = false
    @Previewable @Bindable var symptom: Symptom = SampleSymptoms.symptoms()[0]

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Symptom Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        SymptomView(modelId: symptom.id, in: SampleData.shared.modelContainer)
            .presentationDetents([.medium])
    }
}
