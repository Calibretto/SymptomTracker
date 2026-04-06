//
//  DateTimeRow.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftUI

struct DateTimeRow: View {
    var title: String
    var value: Binding<Date>

    var body: some View {
        GridRow {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
            DatePicker("", selection: value)
                .padding(.vertical, 8)
                .padding(.trailing, 24)
        }
    }
}

#Preview {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    LazyVGrid(columns: columns) {
        DateTimeRow(title: "Preview", value: .constant(Date()))
    }
}
