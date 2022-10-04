//
//  Research.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation

class Research: Identifiable {
    var id: String
    var base: Int
    var name: String
    
    /// Optional, if not present, this is a custom research
    var modIds: [String]
    
    var current: Int
    var purchased: Bool = false
    
    var isCustom: Bool {
        return modIds.isEmpty
    }
    
    init(name: String) {
        self.id = name
        self.base = 0
        self.modIds = []
        self.name = name
        
        self.current = 0
    }
    
    init?(from dict: [String : Any]) {
        guard let name = dict["name"] as? String,
              let cost = dict["cost"] as? Int else { return nil }
        
        self.id = name
        self.base = cost
        self.name = name
        
        self.modIds = dict["modIds"] as? [String] ?? []
        
        self.current = cost
    }
    
    func dict() -> [String : Any] {
        return [
            "cost" : self.base,
            "modIds" : self.modIds,
            "name" : self.name,
            "current" : self.current
        ]
    }
}

extension Research: Equatable {
    static func == (lhs: Research, rhs: Research) -> Bool {
        return lhs.current == rhs.current
        && lhs.purchased == rhs.purchased
    }
}

extension Research: CustomStringConvertible {
    var description: String {
        return "Research { name=\(name), base=\(base), modIds=\(modIds), current=\(current), purchased=\(purchased), isCustom=\(isCustom) }"
    }
}

extension Array where Element == Research {
    func clamped(to group: ResearchGroup) -> [Research] {
        return self.filter({ group.research.map({ $0.id }).contains($0.id) })
    }
}
