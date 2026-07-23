//
//  SettingsView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Version", value: "1.0")
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
