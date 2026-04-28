//
//  TimelineTabView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import SwiftUI
import SwiftData

struct TimelineTabView: View {
    var body: some View {
        VStack {
            Text("Timeline")
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            Spacer()

            TimelineView()

            Spacer()
        }
    }
}

#Preview {
    TimelineTabView()
        .modelContainer(SampleData.shared.modelContainer)
}
