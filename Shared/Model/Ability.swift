//
//  Ability.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/28/22.
//

import Foundation
import SwiftPath

class Ability {
    var description: String = ""
    var info: [String : Any]
    var levelConfiguration: [Int : LevelConfiguration]
    var name: String
    
    var currentLevel: Int = 0
    
    // MARK: Default testing initializer
    init() {
        self.name = "Vein Miner"
        self.levelConfiguration = [
            1 : LevelConfiguration(learningCost: 1, cooldown: 200, levelRequirement: 0),
            2 : LevelConfiguration(learningCost: 1, cooldown: 200, levelRequirement: 0),
            3 : LevelConfiguration(learningCost: 1, cooldown: 200, levelRequirement: 0),
            4 : LevelConfiguration(learningCost: 2, cooldown: 200, levelRequirement: 0),
            5 : LevelConfiguration(learningCost: 2, cooldown: 200, levelRequirement: 0),
        ]
        self.info = [
            "durabilityLevelConfiguration" : [
                [
                    "noDurabilityUsageChance": 0.8,
                    "blockLimit": 4,
                    "learningCost": 1,
                    "behavior": "HOLD_TO_ACTIVATE",
                    "cooldown": 200,
                    "levelRequirement": 15
                ]
            ]
        ]
    }
}

struct LevelConfiguration {
    var learningCost: Int
    var cooldown: Int
    var levelRequirement: Int
}
