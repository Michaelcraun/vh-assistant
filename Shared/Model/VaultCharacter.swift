//
//  Character.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import Foundation

class VaultCharacter: Identifiable, ObservableObject {
    var id: String
    var name: String
    
    @Published var knowledgePoints: Int = 0
    @Published var skillPoints: Int = 5
    
    var abilities: [Ability] = []
    @Published var researches: [ResearchGroup] = []
    var talents: [Talent] = []
    
    init(name: String, with researchGroups: [ResearchGroup]) {
        self.id = UUID().uuidString
        self.name = name
        self.researches = researchGroups
    }
    
    init(from dict: [String : Any]) {
        self.id = dict["id"] as? String ?? "ERROR"
        self.name = dict["name"] as? String ?? "ERROR"
        
        self.knowledgePoints = dict["knowledge"] as? Int ?? 0
        self.skillPoints = dict["skill"] as? Int ?? 0
        
        if let researches = dict["research"] as? [[String : Any]] {
            self.researches = researches.compactMap({ ResearchGroup(from: $0) })
        }
    }
        
    func dict() -> [String : Any] {
        return [
            "id" : self.id,
            "name" : self.name,
            "knowledge" : self.knowledgePoints,
            "skill" : self.skillPoints,
            "research" : self.researches.map({ $0.dict() })
        ]
    }
    
    func canPurchase(ability: Ability, at level: Int) -> Bool {
        return false
    }
    
    func canPurchase(talent: Talent, at level: Int) -> Bool {
        return false
    }
    
    func canPurchase(research: Research) -> Bool {
        guard let group = researches[research],
              let research = group.research.first(where: { $0.id == research.id }) else { return false }
        return research.purchased ? false : knowledgePoints >= research.current
    }
    
    func purchase(ability: Ability) {
        
    }
    
    func purchase(research: Research) {
        guard let group = researches[research],
              let research = group.research.first(where: { $0.id == research.id }) else {
            FirebaseManager.report(error: "Could not find research in character's resarches")
            return
        }
                
        research.purchased = true
        knowledgePoints -= research.current
        
        for researchGroup in researches {
            researchGroup.increaseForPurchasedResearchIn(group: group)
        }
    }
    
    func purchase(talent: Talent) {
        
    }
}

extension VaultCharacter: Equatable {
    static func == (lhs: VaultCharacter, rhs: VaultCharacter) -> Bool {
        return lhs.id == rhs.id
    }
}

extension VaultCharacter: CustomStringConvertible {
    var description: String {
        return "VaultCharacter { id=\(id), name=\(name), knowledgePoints=\(knowledgePoints), skillPoints=\(skillPoints), abilities=, researches=\(researches.map({ $0.description }).joined(separator: ",\n")) }"
    }
}
