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
    var modIds: [String]
    var name: String
    
    var current: Int
    
    init(name: String) {
        self.id = name
        self.base = 0
        self.modIds = []
        self.name = name
        
        self.current = 0
    }
    
    init(from dict: [String : Any]) {
        self.id = dict["name"] as? String ?? "ERROR"
        self.base = dict["cost"] as? Int ?? 0
        self.modIds = dict["modIds"] as? [String] ?? []
        self.name = dict["name"] as? String ?? "ERROR"
        
        self.current = dict["cost"] as? Int ?? 0
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

extension Array where Element == Research {
    
}
