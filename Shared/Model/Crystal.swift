//
//  Crystal.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import Foundation

struct Crystal: Identifiable {
    let id: String = UUID().uuidString
    let short: String
    let modifiers: [String]
    let description: String
}
