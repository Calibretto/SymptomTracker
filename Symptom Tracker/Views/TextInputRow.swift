//
//  TextInputRow.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 26/03/2026.
//

import SwiftUI

struct TextInputRow: View {
    var title: String
    var message: String = ""
    var value: Binding<String>
    
    var body: some View {
        GridRow {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
            TextField(message, text: value)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 1)
                )
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
        TextInputRow(title: "Preview", value: .constant("Input"))
    }
}
