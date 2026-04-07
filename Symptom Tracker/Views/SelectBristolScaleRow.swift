//
//  SelectBristolScaleRow.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftUI

struct SelectBristolScaleRow: View {
    @Binding var value: BristolScale

    var body: some View {
        GridRow {
            Text("Bristol Scale")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
            HStack {
                Picker(selection: $value, label: Text("Bristol Scale")) {
                    ForEach(BristolScale.allCases, id: \.self) { scale in
                        Text("\(scale.rawValue) - \(scale.name)").tag(scale)
                    }
                    // This stops the picker complaining about nil selection
                    Divider().tag(BristolScale.unknown)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 32)
        }
    }
}

#Preview("Bristol Scale") {
    @Previewable @State var scale: BristolScale = .normal_smooth
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        SelectBristolScaleRow(value: $scale)
    }
}
