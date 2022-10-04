//
//  Database.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import Foundation
import SwiftUI

class Database: ObservableObject {
    private let parser = Parser()
    
    var abilities: [Ability] = []
    var researchGroups: [ResearchGroup] = []
    var researches: [Research] = []
    var talents: [Talent] = []
    
    @Published var characters: [VaultCharacter] = []
    @Published var currentCharacter: VaultCharacter?
    
    init() {
        reset()
        fetchCharacters()
    }
    
    convenience init(with characters: [VaultCharacter]) {
        self.init()
        self.characters = characters
    }
    
    func associateDescriptions() {
        let descriptions = parser.parseDescriptions()
        
        for research in researches {
            research.text = descriptions[research.name] ?? "ERROR"
        }
    }
    
    func associateResarch() {
        for group in researchGroups {
            for research in researches {
                if group.research.contains(where: { $0.name == research.name }) {
                    group.associateResearch(research)
                }
            }
        }
    }
    
    func fetchCharacters() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent("character")
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
            if let enumerator = FileManager.default.enumerator(at: path, includingPropertiesForKeys: resourceKeys) {
                for case let fileUrl as URL in enumerator {
                    if !fileUrl.absoluteString.contains("DS_Store") {
                        do {
                            let data = try Data(contentsOf: fileUrl)
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                                self.characters.append(VaultCharacter(from: json))
                            }
                        } catch {
                            print("TAG:", error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func load(character: VaultCharacter) {
        save()
        reset()
        
        currentCharacter = character
    }
    
    func new(character: VaultCharacter) {
        save()
        reset()
        
        character.researches = researchGroups
        characters.append(character)
        currentCharacter = character
        save()
    }
    
    func reset() {
//        self.abilities = parser.parseAbilities()
        self.researchGroups = parser.parseResearchGroups()
        self.researches = parser.parseResearches()
//        self.talents = parser.parseTalents()
        
        self.associateDescriptions()
        self.associateResarch()
    }
    
    func save() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let charPath = dir.appendingPathComponent("character")
            if !FileManager.default.fileExists(atPath: charPath.path) {
                do {
                    try FileManager.default.createDirectory(at: charPath, withIntermediateDirectories: true)
                } catch {
                    print("TAG:", error.localizedDescription)
                }
            }
            
            for character in characters {
                let dict = character.dict()
                
                do {
                    let file = "\(character.id).json"
                    let fileUrl = charPath.appendingPathComponent(file)
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let text = String(data: json, encoding: .utf8)
                    
                    try text?.write(to: fileUrl, atomically: true, encoding: .utf8)
                } catch {
                    print("TAG: ", error.localizedDescription)
                }
            }
        }
    }
}
