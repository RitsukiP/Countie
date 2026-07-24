//
//  MultiView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct MultiView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Counters Yet",
                systemImage: "number.circle",
                description: Text("Your counters will appear here.")
            )
            .navigationTitle("Countie")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addCounter) {
                        Label("Add Counter", systemImage: "plus")
                    }
                }
            }
            
        }
    }
    
    private func addCounter() {
        // TODO: create a new counter
    }
}

#Preview {
    MultiView()
}
