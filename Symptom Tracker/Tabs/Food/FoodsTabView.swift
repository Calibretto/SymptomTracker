//
//  FoodsTabView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 29/03/2026.
//

import SwiftData
import SwiftUI

struct FoodsTabView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showFoods = false
    @State private var showRecordFood = false

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: {
                    showFoods = true
                }, label: {
                    Image(systemName: "fork.knife.circle")
                        .imageScale(.large)
                })
            }
            .padding(.horizontal, 16)
            .overlay {
                Text("Recorded Meals")
                    .frame(maxWidth: .infinity)
            }

            Spacer()

            FoodRecordsView()

            Spacer()

            Button(action: {
                showRecordFood = true
            }, label: {
                Text("Record Food")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(isPresented: $showFoods) {
            FoodsView()
                .modelContext(modelContext)
        }
        .sheet(isPresented: $showRecordFood) {
            FoodRecordView(modelId: nil, in: modelContext.container)
        }
    }
}

#Preview {
    FoodsTabView()
        .modelContainer(SampleData.shared.modelContainer)
}
