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
    var researches: [Research] = []
    var talents: [Talent] = []
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
    
    init(from dict: [String : Any]) {
        self.id = dict["id"] as? String ?? "ERROR"
        self.name = dict["name"] as? String ?? "ERROR"
        
        self.knowledgePoints = dict["knowledge"] as? Int ?? 0
        self.skillPoints = dict["skill"] as? Int ?? 0
        
        if let researches = dict["research"] as? [[String : Any]] {
            self.researches = researches.map({ Research(from: $0) })
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
        return knowledgePoints >= research.current
    }
    
    func purchase(ability: Ability) {
        
    }
    
    func purchase(researh: Research) {
        
    }
    
    func purchase(research: Research) {
        
    }
}
