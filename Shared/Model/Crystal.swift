//
//  Crystal.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import Foundation
import SwiftPath

struct Crystal: Identifiable {
    var id: String? = UUID().uuidString
    let description: String
    let modifiers: [String]
    let name: String
    let short: String
    
    init?(name: String, data: JsonObject?) {
        guard let data = data,
              let path = SwiftPath("$.short"),
              let short = try? path.evaluate(with: data) as? String,
              let path = SwiftPath("$.modifiers"),
              let modifiers = try? path.evaluate(with: data) as? [String],
              let path = SwiftPath("$.description"),
              let description = try? path.evaluate(with: data) as? String else { return nil }
        
        self.name = name
        self.short = short
        self.modifiers = modifiers
        self.description = description
    }
    
    init(name: String, short: String, modifiers: [String], description: String) {
        self.description = description
        self.modifiers = modifiers
        self.name = name
        self.short = short
    }
}
