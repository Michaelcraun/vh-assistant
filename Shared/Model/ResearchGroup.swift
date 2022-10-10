//
//  ResearchGroup.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation

class ResearchGroup: Identifiable {
    var id: String
    
    var globalCostIncrease: Double
    var groupCostIncrease: CostIncrease
    var research: [Research]
    var title: String
    
    var modifier: Int = 0
    
    init?(from dict: [String : Any], with name: String? = nil) {
        if let globalCostIncrease = dict["globalCostIncrease"] as? Double,
              let title = dict["title"] as? String,
              let groupIncreases = dict["groupCostIncrease"] as? [String : Any] {
            self.globalCostIncrease = globalCostIncrease
            self.groupCostIncrease = CostIncrease(from: groupIncreases)
            self.id = name ?? title
            self.title = title
            
            self.modifier = dict["modifier"] as? Int ?? 0
        } else {
            FirebaseManager.report(error: "Could not initialize ResearchGroup from \(dict)")
            return nil
        }
        
        if let researchNames = dict["research"] as? [String] {
            self.research = researchNames.map({ Research(name: $0) })
        } else if let research = dict["research"] as? [[String : Any]] {
            self.research = research.compactMap({ Research(from: $0) })
        } else {
            return nil
        }
    }
    
    func associateResearch(_ associated: Research) {
        if let index = research.firstIndex(where: { $0.id == associated.id }) {
            self.research.remove(at: index)
        }
        self.research.append(associated)
    }
    
    func dict() -> [String : Any] {
        return [
            "id" : id,
            "globalCostIncrease" : globalCostIncrease,
            "groupCostIncrease" : groupCostIncrease.dict(),
            "modifier" : modifier,
            "research" : research.map({ $0.dict() }),
            "title" : title
        ]
    }
    
    func increaseForPurchasedResearchIn(group: ResearchGroup) {
        let increase = Int(group.groupCostIncrease.increaseFor(group: group) ?? group.globalCostIncrease)
        modifier += increase
        for research in research {
            if !research.purchased {
                research.current += increase
                
                if research.current <= 0 {
                    research.current -= increase
                }
            }
        }
    }
}

extension ResearchGroup {
    class CostIncrease {
        var base: Double?
        var decoration: Double?
        var farming: Double?
        var power: Double?
        var processing: Double?
        var storage: Double?
        var vaultUtils: Double?
        
        init(from dict: [String : Any]) {
            self.base = dict["Base"] as? Double
            self.decoration = dict["Decoration"] as? Double
            self.farming = dict["Farming"] as? Double
            self.power = dict["Power"] as? Double
            self.processing = dict["Processing"] as? Double
            self.storage = dict["Storage"] as? Double
            self.vaultUtils = dict["VaultUtils"] as? Double
        }
        
        func dict() -> [String : Any] {
            var dict: [String : Any] = [ : ]
            if base != 0.0 { dict["Base"] = base }
            if farming != 0.0 { dict["Farming"] = farming }
            if power != 0.0 { dict["Power"] = power }
            if processing != 0.0 { dict["Processing"] = processing }
            if storage != 0.0 { dict["Storage"] = storage }
            if vaultUtils != 0.0 { dict["VaultUtils"] = vaultUtils }
            return dict
        }
        
        func increaseFor(group: ResearchGroup) -> Double? {
            switch group.title {
            case "Storage": return storage
            case "Power": return power
            case "Farming": return farming
            case "Processing": return processing
            case "Base": return base
            case "Decoration": return decoration
            default: return nil
            }
        }
    }
}

extension ResearchGroup: Equatable {
    static func == (lhs: ResearchGroup, rhs: ResearchGroup) -> Bool {
        return lhs.research == rhs.research
    }
}

extension ResearchGroup: CustomStringConvertible {
    var description: String {
        return "ResearchGroup { globalCostIncrease=\(globalCostIncrease), groupCostIncrease=\(groupCostIncrease), title=\(title), research=\(research.map({ $0.description }).joined(separator: ",\n")) }"
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
