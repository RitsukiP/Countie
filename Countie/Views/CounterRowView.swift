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

    /// When non-nil the row shows a "+" that calls this. `nil` — the default —
    /// keeps the row a pure display view, which is what `LoadCounterView` needs:
    /// there the whole row is already a selection button.
    var onIncrement: (() -> Void)? = nil

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

            HStack(spacing: 8) {
                if let onIncrement {
                    Button(action: onIncrement) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            // Without a frame the tap target is just the glyph,
                            // far under the 44pt minimum.
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    // In a List row the default style fires the button from a tap
                    // anywhere in the row; .borderless confines it to the frame above.
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Add one to \(counter.name)")
                }

                // Always rendered so the "+" keeps a fixed position instead of
                // sliding left the moment the counter completes.
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .opacity(counter.isDone ? 1 : 0)
                    .accessibilityHidden(!counter.isDone)
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
                .contentTransition(.numericText())
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
            let c = Counter(name: "With + button", goal: 20)
            c.count = 8
            return c
        }()) { }
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
