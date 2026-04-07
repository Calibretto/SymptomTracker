//
//  ContentView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            FoodsTabView()
                .tabItem {
                    Label("Foods", systemImage: "fork.knife.circle")
                }
                .padding(.bottom, 24)

            SymptomsTabView()
                .tabItem {
                    Label("Symptoms", systemImage: "waveform.path.ecg.text.clipboard")
                }
                .padding(.bottom, 24)

            IngredientsView()
                .tabItem {
                    Label("Ingredients", systemImage: "carrot")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
