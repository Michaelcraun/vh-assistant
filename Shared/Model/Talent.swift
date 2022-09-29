//
//  Talent.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation

class Talent {
    var name: String
    
    init(from dict: [String : Any]) {
        self.name = dict["name"] as? String ?? "ERROR"
    }
}

extension Talent {
    class Level {
        var cost: Int
        var levelRequirement: Int
        
        init(from dict: [String : Any]) {
            self.cost = dict["cost"] as? Int ?? 0
            self.levelRequirement = dict["levelRequirement"] as? Int ?? 0
        }
    }
}
