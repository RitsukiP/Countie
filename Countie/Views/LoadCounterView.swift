//
//  LoadCounterView.swift
//  Countie
//
//  Created by Ethan Chen on 25/7/2026.
//

import SwiftUI
import SwiftData

/// Sheet listing saved counters so one can be loaded into `HomeView`.
struct LoadCounterView: View {
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Counter.name) private var counters: [Counter]

    /// Receives the chosen counter, or `nil` for "New Counter".
    let onSelect: (Counter?) -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        onSelect(nil)
                        dismiss()
                    } label: {
                        Label("New Counter", systemImage: "plus.circle")
                    }
                } footer: {
                    if counters.isEmpty {
                        Text("No saved counters yet. Add one from the Multiple tab.")
                    }
                }

                if !counters.isEmpty {
                    Section("Saved") {
                        ForEach(counters) { counter in
                            Button {
                                onSelect(counter)
                                dismiss()
                            } label: {
                                CounterRowView(counter: counter)
                                    // Without this the Spacer region is dead to taps,
                                    // so only the ring and text would be selectable.
                                    .contentShape(Rectangle())
                            }
                            // Keeps the row looking like a row rather than tinted button text.
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Load Counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

// In-memory store: selections here affect nothing outside the canvas.
#Preview {
    let container = try! ModelContainer(
        for: Counter.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    for (name, goal, count) in [("Pushups", 30, 12), ("Laps", nil, 5)] as [(String, Int?, Int)] {
        container.mainContext.insert(Counter.make(name: name, goal: goal, count: count, among: []))
    }
    return LoadCounterView { _ in }
        .modelContainer(container)
}
