//
//  LocationsView.swift
//  Symptom Tracker
//
//  Created by Brian Hackett on 28/04/2026.
//

import SwiftData
import SwiftUI

struct LocationsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Location.name)]) var locations: [Location]

    @State var selectedLocation: Location? = nil
    @State var locationToDelete: Location? = nil
    @State var addLocation: Bool = false
    @State var showDeleteAlert: Bool = false

    func confirmDelete(_ location: Location?) {
        locationToDelete = location
        showDeleteAlert = true
    }

    func delete(_ location: Location?) {
        if let location {
            try? modelContext.transaction {
                let records = SymptomRecord.fetchAllWith(location: location, modelContext: modelContext)
                for record in records {
                    record.location = nil
                }
                modelContext.delete(location)
                try? modelContext.save()
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.foreground)
                }
                Spacer()
            }
            .overlay {
                Text("Locations")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 12)

            Spacer()

            List {
                ForEach(locations, id: \.self) { location in
                    Button {
                        selectedLocation = location
                    } label: {
                        Text(location.name)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            confirmDelete(location)
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                addLocation = true
            }, label: {
                Text("Add Location")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 64)
        }
        .sheet(item: $selectedLocation) { location in
            LocationView(modelId: location.id, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $addLocation) {
            LocationView(modelId: nil, in: modelContext.container)
                .presentationDetents([.medium])
        }
        .alert("Delete?", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive) {
                delete(locationToDelete)
            }
            Button("No", role: .cancel) {
                locationToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this location?\n\nThis will remove it from any symptom records that use it.")
        }
    }
}

#Preview {
    LocationsView()
        .modelContainer(SampleData.shared.modelContainer)
}
