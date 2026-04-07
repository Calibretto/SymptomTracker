//
//  BowelsTabView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct BowelsTabView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showRecordBowelMovement = false

    var body: some View {
        VStack {
            Text("Recorded Bowel Movements")
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            Spacer()

            BowelRecordsView()

            Spacer()

            Button(action: {
                showRecordBowelMovement = true
            }, label: {
                Text("Record Bowel Movement")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(isPresented: $showRecordBowelMovement) {
            BowelRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

#Preview {
    BowelsTabView()
        .modelContainer(SampleData.shared.modelContainer)
}
