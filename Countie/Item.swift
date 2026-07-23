//
//  Item.swift
//  Countie
//
//  Created by Ethan Chen on 24/7/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
