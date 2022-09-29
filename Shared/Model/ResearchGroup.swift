//
//  ResearchGroup.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation

class ResearchGroup {
    var globalCostIncrease: Double
    var groupCostIncrease: CostIncrease
    var name: String
    var research: [Research]
    var title: String
    
    init(from dict: [String : Any], with name: String) {
        self.globalCostIncrease = dict["globalCostIncrease"] as? Double ?? 0.0
        self.groupCostIncrease = CostIncrease(from: dict["groupCostIncrease"] as? [String : Any] ?? [ : ])
        self.name = name
        self.research = (dict["research"] as? [String] ?? []).map({ Research(name: $0) })
        self.title = dict["title"] as? String ?? "ERROR"
    }
}

extension ResearchGroup {
    class CostIncrease {
        var base: Double
        var farming: Double
        var power: Double
        var processing: Double
        var storage: Double
        var vaultUtils: Double
        
        init(from dict: [String : Any]) {
            self.base = dict["Base"] as? Double ?? 0.0
            self.farming = dict["Farming"] as? Double ?? 0.0
            self.power = dict["Power"] as? Double ?? 0.0
            self.processing = dict["Processing"] as? Double ?? 0.0
            self.storage = dict["Storage"] as? Double ?? 0.0
            self.vaultUtils = dict["VaultUtils"] as? Double ?? 0.0
        }
    }
}

extension Array where Element == ResearchGroup {
    subscript(_ research: Research) -> ResearchGroup? {
        return self.first(where: { $0.research.map({ $0.name.lowercased() }).contains(research.name.lowercased()) })
    }
}
