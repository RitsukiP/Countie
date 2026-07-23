//
//  CountieView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct CountieView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Counters Yet",
                systemImage: "number.circle",
                description: Text("Your counters will appear here.")
            )
            .navigationTitle("Countie")
        }
    }
}

#Preview {
    CountieView()
}
