//
//  CounterListView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI
import SwiftData

struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Counter.name) private var counters: [Counter]

    @State private var isAddingCounter = false

    var body: some View {
        NavigationStack {
            Group {
                if counters.isEmpty {
                    ContentUnavailableView(
                        "No Counters Yet",
                        systemImage: "number.circle",
                        description: Text("Your counters will appear here.")
                    )
                } else {
                    List {
                        ForEach(counters) { counter in
                            CounterRowView(counter: counter) { increment(counter) }
                        }
                        .onDelete(perform: deleteCounters)
                    }
                }
            }
            .navigationTitle("Multiple Counters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addCounter) {
                        Label("Add Counter", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingCounter) {
                AddCounterView()
            }
        }
    }

    private func addCounter() {
        isAddingCounter = true
    }

    /// Writes straight through to the store, so Home and the database stay in
    /// step with every tap.
    private func increment(_ counter: Counter) {
        withAnimation {
            counter.increment()
            do {
                try modelContext.save()
            } catch {
                print("⚠️ Countie: failed to save count — \(error)")
            }
        }
    }

    private func deleteCounters(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(counters[index])
            }
            try? modelContext.save()
        }
    }
}

// In-memory store. Tapping + here does show the new row, but only until the
// canvas refreshes.
#Preview("With counters") {
    let container = try! ModelContainer(
        for: Counter.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    for (name, goal, count) in [("No goal", nil, 7), ("In progress", 100, 37), ("Completed", 10, 10)] as [(String, Int?, Int)] {
        container.mainContext.insert(Counter.make(name: name, goal: goal, count: count, among: []))
    }
    return CounterListView()
        .modelContainer(container)
}

#Preview("Empty") {
    CounterListView()
        .modelContainer(for: Counter.self, inMemory: true)
}
