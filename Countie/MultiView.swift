//
//  MultiView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct MultiView: View {
    @State private var isAddingCounter = false

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Counters Yet",
                systemImage: "number.circle",
                description: Text("Your counters will appear here.")
            )
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
}

#Preview {
    MultiView()
}
