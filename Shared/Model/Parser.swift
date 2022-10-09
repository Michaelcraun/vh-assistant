//
//  Downloader.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation
import SwiftPath

class Parser {
    private let shouldLoadFromDevice: Bool = false
    
    func parseAbilities(from json: JsonObject) -> [Ability]? {
        guard let url = Bundle.main.url(forResource: "abilities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else { return nil }
        
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
        
        return nil
    }
    
    func parseDescriptions(from json: JsonObject) -> [String : String]? {
        guard let url = Bundle.main.url(forResource: "skill_descriptions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? JsonObject,
              let path = SwiftPath("$.descriptions"),
              let jsonDescriptions = try? path.evaluate(with: json) as? JsonObject,
              let textPath = SwiftPath("$.text") else {
            return nil
        }
        
        var descriptions: [String : String] = [ : ]
        
        for key in jsonDescriptions.keys {
            if let json = jsonDescriptions[key] as? [JsonObject],
                let text = try? textPath.evaluate(with: json) as? [String] {
                descriptions[key] = text.joined(separator: "")
            } else if let json = jsonDescriptions[key] as? JsonObject,
                      let text = try? textPath.evaluate(with: json) as? String {
                descriptions[key] = text
            } else {
                FirebaseManager.report(error: "Could not find text for \(key)")
            }
        }
        
        return descriptions
    }
    
    func parseResearches(from json: JsonObject) -> [Research]? {
        guard let modPath = SwiftPath("$.MOD_RESEARCHES"),
              let customPath = SwiftPath("$.CUSTOM_RESEARCHES"),
              let modResearches = try? modPath.evaluate(with: json) as? [JsonObject],
              let customResearches = try? customPath.evaluate(with: json) as? [JsonObject] else {
            return nil
        }
        
        var researches: [Research] = []
        
        for data in modResearches {
            guard let research = Research(from: data) else {
                FirebaseManager.report(error: "Could not initialize Research from \(data)")
                continue
            }
            researches.append(research)
        }
        
        for data in customResearches {
            guard let research = Research(from: data) else {
                FirebaseManager.report(error: "Could not initialize Research from \(data)")
                continue
            }
            researches.append(research)
        }
        
        return researches
    }
    
    func parseResearchGroups(from json: JsonObject) -> [ResearchGroup]? {
        guard let path = SwiftPath("$.groups"),
              let groups = try? path.evaluate(with: json) as? JsonObject else {
            return nil
        }
        
        var researchGroups: [ResearchGroup] = []
        
        for key in groups.keys {
            guard let data = groups[key] as? JsonObject else {
                FirebaseManager.report(error: "Cannot parse group data")
                continue
            }
            
            guard let group = ResearchGroup(from: data, with: key) else {
                FirebaseManager.report(error: "Failed to initialize ResearchGroup with key [\(key)] and \(data)")
                continue
            }
            
            researchGroups.append(group)
        }
        
        return researchGroups
    }
    
    func parseTalents(from json: JsonObject) -> [Talent]? {
        return nil
    }
}
