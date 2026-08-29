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
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Counter.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        #if DEBUG
        Counter.seedSampleDataIfEmpty(in: container.mainContext)
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
