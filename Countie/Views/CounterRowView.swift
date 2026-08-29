//
//  CounterRowView.swift
//  Countie
//
//  Created by Ethan Chen on 29/8/2026.
//

import SwiftUI
import SwiftData

/// One counter in `CounterListView`: a progress ring holding the count,
/// with the name and goal beside it.
struct CounterRowView: View {
    let counter: Counter

    private let ringSize: CGFloat = 44
    private let ringWidth: CGFloat = 4

    var body: some View {
        HStack(spacing: 16) {
            ring

            VStack(alignment: .leading, spacing: 2) {
                Text(counter.name)
                    .font(.headline)
                Text(goalCaption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if counter.isDone {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 4)
    }

    /// Faint track, plus a progress arc when the counter has a goal.
    /// A goal-less counter draws the track only, so it reads differently from 0%.
    private var ring: some View {
        ZStack {
            Circle()
                .stroke(Color("CounterRing").opacity(0.2), lineWidth: ringWidth)

            if let progress = counter.progress {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color("CounterRing"),
                        style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))     // start the arc at the top
            }

            Text("\(counter.count)")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(ringWidth + 2)
        }
        .frame(width: ringSize, height: ringSize)
    }

    private var goalCaption: String {
        guard let goal = counter.goal else { return "∞" }
        return "of \(goal)"
    }
}

#Preview {
    List {
        CounterRowView(counter: Counter(name: "No goal"))
        CounterRowView(counter: {
            let c = Counter(name: "In progress", goal: 100)
            c.count = 37
            return c
        }())
        CounterRowView(counter: {
            let c = Counter(name: "Completed", goal: 10)
            c.count = 10
            return c
        }())
    }
    .modelContainer(for: Counter.self, inMemory: true)
}
