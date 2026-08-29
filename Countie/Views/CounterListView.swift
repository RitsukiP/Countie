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
                            CounterRowView(counter: counter)
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

    private func deleteCounters(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(counters[index])
            }
        }
    }
}

#Preview("With counters") {
    let container = try! ModelContainer(
        for: Counter.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    Counter.seedSampleDataIfEmpty(in: container.mainContext)
    return CounterListView()
        .modelContainer(container)
}

#Preview("Empty") {
    CounterListView()
        .modelContainer(for: Counter.self, inMemory: true)
}
