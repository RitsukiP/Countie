//
//  ContentView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Countie", systemImage: "number.circle.fill") {
                CountieView()
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
