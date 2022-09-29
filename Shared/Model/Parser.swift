//
//  Downloader.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation

class Parser {
    func parseAbilities() {
        guard let url = Bundle.main.url(forResource: "abilities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else { fatalError() }
        
        var dicts: [[String : Any]] = []
        for key in json.keys {
            if let ability = json[key] as? [String : Any] {
                var dict: [String : Any] = [ : ]
                dict["name"] = ability["name"]
                
                guard let levels = ability["levelConfiguration"] as? [[String : Any]] else {
                    print("Cannot parse ability for \(ability)")
                    continue
                }
                
                for (index, level) in levels.enumerated() {
                    dict["\(index + 1)"] = level
                }
                
                for key in ability.keys {
                    switch key {
                    case "name":
                        break
                    case "levelConfiguration":
                        break
                    default:
                        dict[key] = ability[key]
                    }
                }
                
                dicts.append(dict)
            }
        }
        
        print(dicts)
    }
    
    func parseResearches() -> [Research] {
        guard let url = Bundle.main.url(forResource: "researches", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else {
            print("Unable to serialize researches_groups.json")
            return []
        }
        
        guard let researches = json["MOD_RESEARCHES"] as? [[String : Any]] else {
            print("Research groups does not contain MOD_RESEARCHES")
            return []
        }
        
        return researches.map({ Research(from: $0) })
    }
    
    func parseResearchGroups() -> [ResearchGroup] {
        var researchGroups: [ResearchGroup] = []
        
        guard let url = Bundle.main.url(forResource: "researches_groups", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else {
            print("Unable to serialize researches_groups.json")
            return []
        }
        
        guard let groups = json["groups"] as? [String : Any] else {
            print("Research groups does not contain groups")
            return []
        }
        
        for key in groups.keys {
            guard let data = groups[key] as? [String : Any] else {
                print("Cannot parse group data")
                continue
            }
            
            researchGroups.append(ResearchGroup(from: data, with: key))
        }
        
        return researchGroups
    }
    
    func parseTalents() {
        
    }
}
