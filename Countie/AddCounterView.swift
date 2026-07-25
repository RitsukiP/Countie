//
//  AddCounterView.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import SwiftUI

struct AddCounterView: View {
    /// Set by SwiftUI when this view is presented as a sheet. Calling it closes the sheet.
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Hello World")
                .navigationTitle("New Counter")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { dismiss() }) {
                            Label("Close", systemImage: "xmark")
                        }
                    }
                }
        }
    }
}

#Preview {
    AddCounterView()
}
