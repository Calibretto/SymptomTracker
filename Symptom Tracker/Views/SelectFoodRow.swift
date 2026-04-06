//
//  SelectFoodRow.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 05/04/2026.
//

import SwiftData
import SwiftUI

struct SelectFoodRow: View {
    @Binding var value: Food?
    @Binding var foods: [Food]

    var addFoodAction: () -> Void

    var body: some View {
        GridRow {
            Text("Food")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
            HStack {
                if foods.count > 0 {
                    Picker(selection: $value, label: Text("Food")) {
                        ForEach(foods, id: \.self) { food in
                            Text(food.name).tag(food)
                        }
                        // This stops the picker complaining about nil selection
                        Divider().tag(Food?(nil))
                    }
                    .onAppear {
                        if value == nil {
                            value = foods.first
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Button {
                    addFoodAction()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 32)
        }
        .onAppear {
            if value == nil {
                value = foods.first
            }
        }
    }
}

#Preview("Foods") {
    @Previewable @State var food: Food?
    @Previewable @State var foods = SampleFoods.foods()
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        SelectFoodRow(value: $food, foods: $foods) {}
    }
}

#Preview("No Foods") {
    @Previewable @State var food: Food?
    @Previewable @State var foods: [Food] = []
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        SelectFoodRow(value: $food, foods: $foods) {}
    }
}
