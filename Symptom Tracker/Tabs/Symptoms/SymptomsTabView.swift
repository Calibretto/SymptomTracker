//
//  SymptomsTabView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftData
import SwiftUI

struct SymptomsTabView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showSymptoms = false
    @State private var showRecordSymptom = false

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: {
                    showSymptoms = true
                }, label: {
                    Image(systemName: "waveform.path.ecg.text.clipboard.fill")
                        .imageScale(.large)
                })
            }
            .padding(.horizontal, 16)
            .overlay {
                Text("Recorded Symptoms")
                    .frame(maxWidth: .infinity)
            }

            Spacer()

            SymptomRecordsView()

            Spacer()

            Button(action: {
                showRecordSymptom = true
            }, label: {
                Text("Record Symptom")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(isPresented: $showSymptoms) {
            SymptomsView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showRecordSymptom) {
            SymptomRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

#Preview {
    SymptomsTabView()
        .modelContainer(SampleData.shared.modelContainer)
}
