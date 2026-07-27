//
//  HomeView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var count = 0

    var body: some View {
        NavigationStack {
            Circle()
                .strokeBorder(Color.blue, lineWidth: 12)
                .frame(width: 280, height: 280)
                .overlay {
                    Text("\(count)")
                        .font(.system(size: 96, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .padding(48)
                }
                .contentShape(Circle())
                .onTapGesture {
                    withAnimation {
                        count += 1
                    }
                }
                .navigationTitle("Countie")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: saveCounter) {
                            Label("Save Counter", systemImage: "square.and.arrow.down")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: loadCounter) {
                            Label("Load Counter", systemImage: "tray.and.arrow.up")
                        }
                        // .buttonStyle(.borderedProminent)
                        // .tint(.orange)
                    }
                }
        }
    }
    private func saveCounter() {
        // TODO: save this counter
    }
    
    private func loadCounter() {
        // TODO: load an existing counter
    }
}

#Preview {
    HomeView()
}
