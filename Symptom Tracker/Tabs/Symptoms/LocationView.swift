//
//  LocationView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import SwiftData
import SwiftUI

struct LocationView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @Bindable var location: Location
    var addedAction: ((Location) -> Void)?

    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer,
        addedAction: ((Location) -> Void)? = nil
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        if let modelId {
            if let location = modelContext.model(for: modelId) as? Location {
                self.location = location
                isNew = false
            } else {
                location = Location.empty()
                isNew = true
            }
        } else {
            location = Location.empty()
            isNew = true
        }

        self.addedAction = addedAction
    }

    func save() {
        do {
            if isNew {
                modelContext.insert(location)
            }
            try modelContext.save()

            addedAction?(location)
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
                Text("Location")
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                TextField("Enter a name...", text: $location.name)
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
                    Text("Add Location")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Location")
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
    LocationView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - New") {
    @Previewable @State var sheetOpen = false

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Location Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        LocationView(modelId: nil, in: SampleData.shared.modelContainer)
            .presentationDetents([.medium])
    }
}
