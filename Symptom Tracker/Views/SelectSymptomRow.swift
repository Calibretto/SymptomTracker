//
//  SelectSymptomRow.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct SelectSymptomRow: View {
    @Binding var value: Symptom?
    @Binding var symptoms: [Symptom]

    var addSymptomAction: () -> Void

    var body: some View {
        GridRow {
            Text("Symptom")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
            HStack {
                if symptoms.count > 0 {
                    Picker(selection: $value, label: Text("Symptom")) {
                        ForEach(symptoms, id: \.self) { symptom in
                            Text(symptom.name).tag(symptom)
                        }
                        // This stops the picker complaining about nil selection
                        Divider().tag(Symptom?(nil))
                    }
                    .onAppear {
                        if value == nil {
                            value = symptoms.first
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Button {
                    addSymptomAction()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 32)
        }
    }
}

#Preview("Symptoms") {
    @Previewable @State var symptom: Symptom?
    @Previewable @State var symptoms = SampleSymptoms.symptoms()
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        SelectSymptomRow(value: $symptom, symptoms: $symptoms) {}
    }
}

#Preview("No Symptoms") {
    @Previewable @State var symptom: Symptom?
    @Previewable @State var symptoms: [Symptom] = []
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        SelectSymptomRow(value: $symptom, symptoms: $symptoms) {}
    }
}
