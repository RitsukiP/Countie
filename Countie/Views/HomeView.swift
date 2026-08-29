//
//  HomeView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Counter.name) private var counters: [Counter]

    /// Which counter is loaded, remembered across launches.
    @AppStorage("loadedCounterUID") private var loadedCounterUID = ""

    /// Used only when no counter is loaded, so Home still works as a scratch pad.
    @State private var scratchCount = 0

    @State private var isSavingCounter = false
    @State private var isLoadingCounter = false

    /// Derived from `@Query` rather than held in `@State`: if the loaded counter is
    /// deleted on the Multiple tab this becomes nil on its own, instead of leaving a
    /// dangling reference to a deleted model.
    private var loadedCounter: Counter? {
        guard let uuid = UUID(uuidString: loadedCounterUID) else { return nil }
        return counters.first { $0.uid == uuid }
    }

    private var count: Int { loadedCounter?.count ?? scratchCount }

    var body: some View {
        NavigationStack {
            Circle()
                .strokeBorder(Color("CounterRing").opacity(loadedCounter?.progress == nil ? 1 : 0.2),
                              lineWidth: 12)
                .frame(width: 280, height: 280)
                .overlay {
                    // Progress arc, only when the loaded counter has a goal.
                    if let progress = loadedCounter?.progress {
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                Color("CounterRing"),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))   // start the arc at the top
                            .padding(6)                      // sit on the stroked border
                    }
                }
                .overlay {
                    VStack(spacing: 4) {
                        Text("\(count)")
                            .font(.system(size: 96, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        if let goal = loadedCounter?.goal {
                            Text("of \(goal)")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(48)
                }
                .contentShape(Circle())
                .onTapGesture(perform: increment)
                .navigationTitle(loadedCounter?.name ?? "Countie")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $isSavingCounter) {
                    if let loadedCounter {
                        AddCounterView(editing: loadedCounter)
                    } else {
                        AddCounterView(initialCount: scratchCount)
                    }
                }
                .sheet(isPresented: $isLoadingCounter) {
                    LoadCounterView { selection in
                        if let selection {
                            loadedCounterUID = selection.uid.uuidString
                        } else {
                            loadedCounterUID = ""
                            scratchCount = 0
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: saveCounter) {
                            Label("Save Counter", systemImage: "square.and.arrow.down.on.square")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: loadCounter) {
                            Label("Load Counter", systemImage: "tray.and.arrow.up")
                        }
                    }
                }
        }
    }

    /// With a counter loaded this writes straight through to the store, so the
    /// Multiple tab and the database stay in step with every tap.
    private func increment() {
        withAnimation {
            if let loadedCounter {
                loadedCounter.count += 1
                do {
                    try modelContext.save()
                } catch {
                    print("⚠️ Countie: failed to save count — \(error)")
                }
            } else {
                scratchCount += 1
            }
        }
    }

    private func saveCounter() {
        isSavingCounter = true
    }

    private func loadCounter() {
        isLoadingCounter = true
    }
}

// In-memory store: saving from the sheet works but nothing persists in the canvas.
#Preview("Light") {
    HomeView()
        .modelContainer(for: Counter.self, inMemory: true)
}

#Preview("Dark") {
    HomeView()
        .preferredColorScheme(.dark)
        .modelContainer(for: Counter.self, inMemory: true)
}
