//
//  TimelineTabView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import SwiftUI
import SwiftData

struct TimelineTabView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showRecordFood = false
    @State private var showRecordDrink = false
    @State private var showRecordSymptom = false
    @State private var showRecordBowel = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Text("Timeline")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                TimelineView()
            }

            Menu {
                Button {
                    showRecordFood = true
                } label: {
                    Label("Food", systemImage: "fork.knife.circle")
                }
                Button {
                    showRecordDrink = true
                } label: {
                    Label("Drink", systemImage: "cup.and.saucer")
                }
                Button {
                    showRecordSymptom = true
                } label: {
                    Label("Symptom", systemImage: "waveform.path.ecg")
                }
                Button {
                    showRecordBowel = true
                } label: {
                    Label("Bowel Movement", systemImage: "toilet")
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.white, .blue)
                    .shadow(radius: 4)
            }
            .padding(.trailing, 24)
            .padding(.bottom, 12)
        }
        .sheet(isPresented: $showRecordFood) {
            FoodRecordView(modelId: nil, in: modelContext.container)
        }
        .sheet(isPresented: $showRecordDrink) {
            DrinkRecordView(modelId: nil, in: modelContext.container)
        }
        .sheet(isPresented: $showRecordSymptom) {
            SymptomRecordView(modelId: nil, in: modelContext.container)
        }
        .sheet(isPresented: $showRecordBowel) {
            BowelRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

#Preview {
    TimelineTabView()
        .modelContainer(SampleData.shared.modelContainer)
}
