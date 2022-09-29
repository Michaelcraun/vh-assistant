//
//  ResearchGroup.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation

class ResearchGroup: Identifiable {
    var globalCostIncrease: Double
    var groupCostIncrease: CostIncrease
    var id: String
    var research: [Research]
    var title: String
    
    init(from dict: [String : Any], with name: String) {
        self.globalCostIncrease = dict["globalCostIncrease"] as? Double ?? 0.0
        self.groupCostIncrease = CostIncrease(from: dict["groupCostIncrease"] as? [String : Any] ?? [ : ])
        self.id = name
        self.research = (dict["research"] as? [String] ?? []).map({ Research(name: $0) })
        self.title = dict["title"] as? String ?? "ERROR"
    }
    
    func associateResearch(_ associated: Research) {
        if let index = research.firstIndex(where: { $0.id == associated.id }) {
            self.research.remove(at: index)
        }
        self.research.append(associated)
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
    
    func sorted() -> [ResearchGroup] {
        var sorted: [ResearchGroup] = []
        if let storage = self.first(where: { $0.id == "Storage" }) { sorted.append(storage) }
        if let decoration = self.first(where: { $0.id == "Decoration" }) { sorted.append(decoration) }
        if let power = self.first(where: { $0.id == "Power" }) { sorted.append(power) }
        if let farming = self.first(where: { $0.id == "Farming" }) { sorted.append(farming) }
        if let processing = self.first(where: { $0.id == "Processing" }) { sorted.append(processing) }
        if let base = self.first(where: { $0.id == "Base" }) { sorted.append(base) }
        if let utilities = self.first(where: { $0.id == "Utilities" }) { sorted.append(utilities) }
        return sorted
    }
}
