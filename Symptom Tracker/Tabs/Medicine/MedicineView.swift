//
//  MedicineView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct MedicineView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @Bindable var medicine: Medicine
    var addedAction: ((Medicine) -> Void)?

    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer,
        addedAction: ((Medicine) -> Void)? = nil
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        if let modelId {
            if let medicine = modelContext.model(for: modelId) as? Medicine {
                self.medicine = medicine
                isNew = false
            } else {
                medicine = Medicine.empty()
                isNew = true
            }
        } else {
            medicine = Medicine.empty()
            isNew = true
        }

        self.addedAction = addedAction
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(medicine)
            }
            try modelContext.save()

            addedAction?(medicine)
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
                Text("Medicine")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                TextField("Enter a name...", text: $medicine.name)
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
                    Text("Add Medicine")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Medicine")
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

#Preview("View Only - New") {
    MedicineView(modelId: nil, in: SampleData.shared.modelContainer)
}
