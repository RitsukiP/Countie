//
//  Counter.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import Foundation
import SwiftData

@Model      // transform this class into a persistant model
final class Counter {
    /// Name shown to the user. Defaults to "Counter 1", "Counter 2", … via `make(name:goal:among:)`.
    var name: String

    /// How many times the user has counted up.
    var count: Int = 0

    /// Target the counter is working towards. `nil` means the counter has no goal.
    var goal: Int?      // '?' means optional

    /// Identifies this counter internally. Never shown to the user.
    @Attribute(.unique) private(set) var uid: UUID = UUID()

    /// True once a counter with a goal has reached it.
    var isDone: Bool {
        guard let goal else { return false }
        return count >= goal
    }

    /// Fraction of the goal reached (0...1), or `nil` when there is no usable goal.
    var progress: Double? {
        guard let goal, goal > 0 else { return nil }
        return min(Double(count) / Double(goal), 1)
    }
    
    // default initialisation
    init(name: String, goal: Int? = nil) {
        self.name = name
        self.goal = goal
    }
}

extension Counter {
    private static let defaultNamePrefix = "Counter "

    /// The lowest unused "Counter N" name among `existing`.
    ///
    /// Deriving the number from stored counters (rather than a running total) keeps
    /// naming correct across relaunches, and frees a number again when its counter
    /// is deleted.
    static func defaultName(among existing: [Counter]) -> String {
        let used = Set(existing.compactMap { counter -> Int? in
            guard counter.name.hasPrefix(defaultNamePrefix) else { return nil }
            return Int(counter.name.dropFirst(defaultNamePrefix.count))
        })

        var number = 1
        while used.contains(number) {
            number += 1
        }
        return "\(defaultNamePrefix)\(number)"
    }

    /// Creates a counter, naming it automatically when `name` is nil or blank.
    static func make(name: String? = nil, goal: Int? = nil, among existing: [Counter]) -> Counter {
        let trimmed = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let resolvedName = trimmed.isEmpty ? defaultName(among: existing) : trimmed
        return Counter(name: resolvedName, goal: goal)
    }
}
