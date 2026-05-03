//
//  BowelRecordView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct BowelRecordView: View {

    @Environment(\.dismiss) private var dismiss

    var modelContext: ModelContext
    @State var record: BowelMovementRecord
    private var isNew: Bool

    @State private var showingAlert = false
    @State private var errorMessage = "No Error"

    init(
        modelId: PersistentIdentifier?,
        in container: ModelContainer
    ) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false

        if let modelId {
            if let record = modelContext.model(for: modelId) as? BowelMovementRecord {
                self.record = record
                isNew = false
            } else {
                record = BowelMovementRecord.new()
                isNew = true
            }
        } else {
            record = BowelMovementRecord.new()
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
                Text("Bowel Movement Record")
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
                    Text("Bristol Scale")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    Picker("Bristol Scale", selection: $record.scale) {
                        ForEach(BristolScale.allCases, id: \.self) { scale in
                            Text("\(scale.rawValue) - \(scale.name)").tag(scale)
                        }
                        Divider().tag(BristolScale.unknown)
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
                    Text("Add Bowel Movement Record")
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Save Bowel Movement Record")
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

#Preview("View Only - Existing", traits: .modifier(SampleData.shared)) {
    @Previewable @Query var records: [BowelMovementRecord]

    BowelRecordView(modelId: records[0].id, in: SampleData.shared.modelContainer)
}

#Preview("View Only - New") {
    BowelRecordView(modelId: nil, in: SampleData.shared.modelContainer)
}

#Preview("Sheet - Existing", traits: .modifier(SampleData.shared)) {
    @Previewable @Query var records: [BowelMovementRecord]
    @Previewable @State var sheetOpen = false

    VStack {
        Spacer()
        Button {
            sheetOpen = true
        } label: {
            Text("Open Bowel Movement Record Sheet")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
    }
    .sheet(isPresented: $sheetOpen) {
        BowelRecordView(modelId: records[0].id, in: SampleData.shared.modelContainer)
            .presentationDetents([.medium])
    }
}
