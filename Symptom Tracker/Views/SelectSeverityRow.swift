//
//  SelectSeverityRow.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 07/04/2026.
//

import SwiftData
import SwiftUI

struct SelectSeverityRow: View {
    @Binding var value: UInt

    var body: some View {
        GridRow {
            Text("Severity")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
            HStack {
                Picker(selection: $value, label: Text("Severity")) {
                    ForEach(UInt(1)...UInt(11), id: \.self) { severity in
                        Text("\(severity)").tag(severity)
                    }
                    // This stops the picker complaining about nil selection
                    Divider().tag(UInt(99))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 32)
        }
    }
}

#Preview("Severity") {
    @Previewable @State var severity: UInt = 5
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        SelectSeverityRow(value: $severity)
    }
}
