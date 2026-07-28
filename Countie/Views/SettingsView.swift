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
                    LabeledContent("Version", value: "0.1.0")
                    LabeledContent("Current iOS version", value: UIDevice.current.systemVersion)
                } header: {
                    Text("About")
                }
                Section {
                    // add section here
                } header: {
                    Text("Support")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
