//
//  AddCounterView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI
import SwiftData

struct AddCounterView: View {
    /// Set by SwiftUI when this view is presented as a sheet. Calling it closes the sheet.
    @Environment(\.dismiss) private var dismiss

    /// Existing counters, used to work out the "Counter N" placeholder.
    @Query private var counters: [Counter]

    @State private var name = ""
    @State private var goalText = ""

    /// Placeholder shown in the name field, and the name used when it's left blank.
    private var defaultName: String {
        Counter.defaultName(among: counters)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField(defaultName, text: $name)
                }

                Section {
                    TextField("∞", text: $goalText)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Goal")
                } footer: {
                    Text("Leave empty to count without a goal.")
                }
            }
            .navigationTitle("New Counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Label("Close", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: saveCounter) {
                        Label("Save", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
        }
    }

    private func saveCounter() {
        // TODO: create the counter from `name` / `goalText` and insert it
    }
}

#Preview {
    AddCounterView()
        .modelContainer(for: Counter.self, inMemory: true)
}
