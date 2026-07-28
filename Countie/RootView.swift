//
//  RootView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "number.circle.fill") {
                HomeView()
            }
            Tab("Multiple", systemImage: "rectangle.grid.1x3") {
                CounterListView()
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
    }
}

#Preview("Light") {
    RootView()
}

#Preview("Dark") {
    RootView()
        .preferredColorScheme(.dark)
}
