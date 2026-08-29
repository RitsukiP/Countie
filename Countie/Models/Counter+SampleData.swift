//
//  Counter+SampleData.swift
//  Countie
//
//  Created by Ethan Chen on 28/7/2026.
//

#if DEBUG
import Foundation
import SwiftData

extension Counter {
    /// Inserts three sample counters, but only when the store is empty.
    ///
    /// Names come from `make(name:goal:among:)` rather than literals, so the seed
    /// runs the same auto-naming path a real user hits and yields
    /// "Counter 1", "Counter 2", "Counter 3".
    @MainActor
    static func seedSampleDataIfEmpty(in context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<Counter>())) ?? []
        guard existing.isEmpty else { return }

        var created: [Counter] = []
        for goal in [nil, 100, 1000] as [Int?] {
            let counter = Counter.make(goal: goal, among: created)
            context.insert(counter)
            created.append(counter)
        }
        try? context.save()
    }
}
#endif
