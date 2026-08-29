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
    @Environment(\.modelContext) private var modelContext

    /// Existing counters, used to work out the "Counter N" placeholder.
    @Query private var counters: [Counter]

    @State private var name: String
    @State private var countText: String
    @State private var goalText: String

    /// The counter being edited, or `nil` when creating a new one.
    private let editing: Counter?

    /// `initialCount` lets the Home tab open this sheet pre-filled with its count.
    /// Zero maps to an empty field so the "0" placeholder shows instead.
    init(initialCount: Int = 0) {
        editing = nil
        _name = State(initialValue: "")
        _countText = State(initialValue: initialCount == 0 ? "" : String(initialCount))
        _goalText = State(initialValue: "")
    }

    /// Opens the sheet on an existing counter; saving updates that instance
    /// rather than inserting a new one.
    init(editing counter: Counter) {
        editing = counter
        _name = State(initialValue: counter.name)
        _countText = State(initialValue: String(counter.count))
        _goalText = State(initialValue: counter.goal.map(String.init) ?? "")
    }

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

                Section("Current Count") {
                    TextField("0", text: $countText)
                        .keyboardType(.numberPad)
                        .onChange(of: countText) { _, newValue in
                            countText = newValue.filter(\.isNumber)
                        }
                }

                Section {
                    TextField("∞", text: $goalText)
                        .keyboardType(.numberPad)
                        .onChange(of: goalText) { _, newValue in
                            goalText = newValue.filter(\.isNumber)
                        }
                } header: {
                    Text("Goal")
                } footer: {
                    Text("Leave empty to count without a goal.")
                }
            }
            .navigationTitle(editing == nil ? "New Counter" : "Edit Counter")
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
        // A goal of 0 is treated as "no goal": otherwise `isDone` would be true
        // for a brand-new counter while `progress` reported nil.
        let goal = Int(goalText).flatMap { $0 > 0 ? $0 : nil }
        let count = Int(countText) ?? 0

        if let editing {
            // Exclude self so a blank name doesn't collide with this counter's own.
            editing.name = Counter.resolvedName(name, among: counters.filter { $0.uid != editing.uid })
            editing.goal = goal
            editing.count = count
        } else {
            modelContext.insert(
                Counter.make(name: name, goal: goal, count: count, among: counters)
            )
        }
        // Flush immediately: autosave alone can lose the counter if the app is
        // force-quit or crashes before SwiftData gets round to writing.
        do {
            try modelContext.save()
        } catch {
            // Surfaced rather than swallowed: a silent failure here looks
            // identical to "the save button does nothing".
            print("⚠️ Countie: failed to save counter — \(error)")
        }
        dismiss()
    }
}

// Previews use an in-memory store: saves here are real but land in a throwaway
// database that is discarded on every canvas refresh, and each #Preview gets its
// own. To see a save persist, run the app (⌘R) instead.
#Preview("Empty") {
    AddCounterView()
        .modelContainer(for: Counter.self, inMemory: true)
}

#Preview("Pre-filled from Home") {
    AddCounterView(initialCount: 42)
        .modelContainer(for: Counter.self, inMemory: true)
}
