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
                    print("TAG: Cannot parse ability for \(ability)")
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
            print("TAG: Unable to serialize researches_groups.json")
            return []
        }
        
        var researches: [Research] = []
        
        guard let modResearches = json["MOD_RESEARCHES"] as? [[String : Any]] else {
            print("TAG: Research groups does not contain MOD_RESEARCHES")
            return []
        }
        
        for data in modResearches {
            guard let research = Research(from: data) else {
                print("TAG: Could not initialize Research from \(data)")
                continue
            }
            researches.append(research)
        }
        
        guard let customResearches = json["CUSTOM_RESEARCHES"] as? [[String : Any]] else {
            print("TAG: Research groups does not contain MOD_RESEARCHES")
            return []
        }
        
        for data in customResearches {
            guard let research = Research(from: data) else {
                print("TAG: Could not initialize Research from \(data)")
                continue
            }
            researches.append(research)
        }
        
        return researches
    }
    
    func parseResearchGroups() -> [ResearchGroup] {
        var researchGroups: [ResearchGroup] = []
        
        guard let url = Bundle.main.url(forResource: "researches_groups", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else {
            print("TAG: Unable to serialize researches_groups.json")
            return []
        }
        
        guard let groups = json["groups"] as? [String : Any] else {
            print("TAG: Research groups does not contain groups")
            return []
        }
        
        for key in groups.keys {
            guard let data = groups[key] as? [String : Any] else {
                print("TAG: Cannot parse group data")
                continue
            }
            
            guard let group = ResearchGroup(from: data, with: key) else {
                print("TAG: Failed to initialize ResearchGroup with key [\(key)] and \(data)")
                continue
            }
            
            researchGroups.append(group)
        }
        
        return researchGroups
    }
    
    func parseTalents() {
        
    }
}
