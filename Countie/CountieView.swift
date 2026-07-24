//
//  CountieView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct CountieView: View {
    @State private var count = 0

    var body: some View {
        NavigationStack {
            Circle()
                .strokeBorder(Color.blue, lineWidth: 14)
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
        }
    }
}

#Preview {
    CountieView()
}
