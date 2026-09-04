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

    /// Name of the loaded counter, or nil when counting on an unsaved scratch counter.
    private var displayName: String? {
        guard let name = loadedCounter?.name, !name.isEmpty else { return nil }
        return name
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                header

                Spacer()

                VStack(spacing: 16) {
                    counterNameLabel
                    ring
                }
                .frame(maxWidth: .infinity)   // centres the name + ring group

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .toolbar(.hidden, for: .navigationBar)
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
        }
    }

    /// Glass buttons size themselves to their content, and `tray.and.arrow.up` is a
    /// much larger glyph than `plus` — without a shared box the two capsules differ.
    private let headerIconSize: CGFloat = 24

    /// Title and buttons on one row. Built as content rather than as toolbar items:
    /// the navigation bar sizes items to its own ~44pt height, and at 40pt iOS pushes
    /// an oversized item into a "..." overflow menu instead of showing it.
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Countie")
                .font(.system(size: 40, weight: .light).width(.expanded))

            Spacer()

            HStack(spacing: 12) {
                Button(action: loadCounter) {
                    Label("Load Counter", systemImage: "tray.and.arrow.up")
                        .frame(width: headerIconSize, height: headerIconSize)
                }
                .buttonStyle(.glass)
                Button(action: saveCounter) {
                    Label("Save Counter", systemImage: "plus")
                        .frame(width: headerIconSize, height: headerIconSize)
                }
                .buttonStyle(.glassProminent)
            }
            .labelStyle(.iconOnly)
            .font(.title3)
            .alignmentGuide(.firstTextBaseline) { $0[VerticalAlignment.center] + 8 }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    /// Renders a blank-but-invisible line when there is no name, so the ring keeps a
    /// fixed vertical position instead of jumping as counters are loaded/unloaded.
    private var counterNameLabel: some View {
        Text(displayName ?? " ")
            .font(.title3)
            .foregroundStyle(.secondary)
            .opacity(displayName == nil ? 0 : 1)
            .accessibilityHidden(displayName == nil)
    }

    private var ring: some View {
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
