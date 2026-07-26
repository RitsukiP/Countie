//
//  CountieApp.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI
import SwiftData

@main
struct CountieApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: Counter.self)
    }
}
