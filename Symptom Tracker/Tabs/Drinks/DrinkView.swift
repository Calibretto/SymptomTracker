//
//  DrinkView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 02/05/2026.
//

import SwiftData
import SwiftUI

struct DrinkView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @Bindable var drink: Drink
    var addedAction: ((Drink) -> Void)?

    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer,
        addedAction: ((Drink) -> Void)? = nil
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        if let modelId {
            if let drink = modelContext.model(for: modelId) as? Drink {
                self.drink = drink
                isNew = false
            } else {
                drink = Drink.empty()
                isNew = true
            }
        } else {
            drink = Drink.empty()
            isNew = true
        }

        self.addedAction = addedAction
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(drink)
            }
            try modelContext.save()

            addedAction?(drink)
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
                Text("Drink")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                TextField("Enter a name...", text: $drink.name)
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
                    Text("Add Drink")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Drink")
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
    DrinkView(modelId: nil, in: SampleData.shared.modelContainer)
}
