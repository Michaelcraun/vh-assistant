//
//  Firebase.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/6/22.
//

import Foundation
import FirebaseAuth
import FirebaseCrashlytics
import FirebaseStorage
import SwiftPath

class FirebaseManager: ObservableObject {
    typealias AuthorizationCompletion = (String?) -> Void
    typealias DownloadCompletion = (JsonObject?, String?) -> Void
    typealias UploadCompletion = (String?) -> Void
    
    var user: User?
    #warning("TODO: Eventually support version switching!")
    @Published var version: String = "1.16.5"
    @Published var isWorking: Bool = false
    @Published var step: String = ""
    @Published var error: Error?
    var files: [String : String] = [ : ]
    let parser = Parser()
    
    @Published var characters: [VaultCharacter] = []
    @Published var currentCharacter: VaultCharacter?
    var abilities: [Ability] = []
    var crystals: [Crystal] = []
    var descriptions: [String : String] = [ : ]
    var researchGroups: [ResearchGroup] = []
    var researches: [Research] = []
    var talents: [Talent] = []
    
    init() {
        _ = $error.sink { error in
            if let error = error {
                FirebaseManager.report(error: error.localizedDescription)
            }
        }
    }
    
    convenience init(with characters: [VaultCharacter]) {
        self.init()
        self.characters = characters
    }
    
    func start() {
        isWorking.toggle()
        
        authorize { error in
            if let error = error {
                self.error = error
            } else {
                let group = DispatchGroup()
                
                #if DEBUG
                self.sync(in: group)
                #endif
                
                // Download files information for this specific version
                self.step = "Downloading version information"
                self.download(file: self.version, ext: "json") { object, error in
                    if let error = error {
                        self.error = error
                        self.isWorking.toggle()
                    } else if let fileList = object as? [String : String] {
                        self.files = fileList
                        
                        // Download individual files listed in the version info
                        for file in self.files.keys {
                            guard let current = self.files[file] else {
                                self.isWorking.toggle()
                                return
                            }
                            
                            print("TAG: Downloading \(file)...")
                            self.step = "Downloading \(current) files..."
                            
                            group.enter()
                            self.download(file: "\(self.version)/\(file)", ext: "json") { object, error in
                                if let error = error {
                                    self.error = error
                                } else if let object = object {
                                    if let crystals = self.parser.parseCrystals(from: object) {
                                        self.crystals = crystals
                                    } else if let researchGroups = self.parser.parseResearchGroups(from: object) {
                                        self.researchGroups = researchGroups
                                    } else if let researches = self.parser.parseResearches(from: object) {
                                        self.researches = researches
                                    } else if let abilities = self.parser.parseAbilities(from: object) {
                                        self.abilities = abilities
                                    } else if let talents = self.parser.parseTalents(from: object) {
                                        self.talents = talents
                                    } else if let descriptions = self.parser.parseDescriptions(from: object) {
                                        self.descriptions = descriptions
                                    } else {
                                        FirebaseManager.report(error: "Unable to parse \(object)")
                                    }
                                } else {
                                    self.error = "Unable to download and parse latest \(current) files..."
                                }
                                group.leave()
                            }
                        }
                        
                        group.notify(queue: .main) {
                            self.associateDescriptions()
                            self.associateResarch()
                            self.fetchCharacters()
                            
                            self.isWorking.toggle()
                        }
                    } else {
                        self.error = "Could not get version info for \(self.version)"
                    }
                }
            }
        }
    }
    
    func load(character: VaultCharacter) {
        // Save current character, if any, so no progress is lost then load
        // the new one into RAM
        save(character: currentCharacter)
        currentCharacter = character
    }
    
    func new(character: VaultCharacter) {
        save(character: currentCharacter)
        
        // Update character with current research groups, abilities, and talents
        // and add them to the currently existing characters
        character.researches = researchGroups
        characters.append(character)
        
        // Set as current and save
        currentCharacter = character
        save(character: currentCharacter)
    }
    
    func save(character: VaultCharacter?) {
        if let character = character {
            let dictionary = character.dict()
            do {
                guard let uid = user?.uid else {
                    self.error = "User is not signed in."
                    return
                }
                let path = "character/\(uid)"
                let json = try JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
                self.upload(data: json, file: character.id, ext: "json", to: path) { error in
                    if let error = error {
                        self.error = error
                    } else {
                        guard let index = self.characters.firstIndex(where: { $0.id == character.id }) else {
                            self.error = "[\(character.id)]\nPlaythrough not found!"
                            return
                        }
                        self.characters[index] = character
                    }
                }
            } catch {
                self.error = error
            }
        }
    }
    
    private func authorize(completion: @escaping AuthorizationCompletion) {
        self.step = "Authorizing..."
        
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                completion(error.localizedDescription)
            } else if let user = result?.user {
                self.user = user
                completion(nil)
            } else {
                completion("Unable to sign in")
            }
        }
    }
    
    private func download(file: String, ext: String? = nil, completion: @escaping DownloadCompletion) {
        let ext = ext == nil ? "" : ".\(ext ?? "")"
        let filename = "\(file)\(ext)"
        
        Storage.storage().reference().child(filename).getData(maxSize: Int64(5*1024*1045)) { data, error in
            if let error = error {
                completion(nil, "[\(filename)]\n\(error.localizedDescription)")
            } else if let data = data {
                do {
                    let data = try JSONSerialization.jsonObject(with: data) as? JsonObject
                    if let data = data {
                        completion(data, nil)
                    } else {
                        completion(nil, "[\(filename)]\nUnable to serialize downloaded file.")
                    }
                } catch {
                    completion(nil, "[\(filename)]\n\(error.localizedDescription)")
                }
            } else {
                completion(nil, "[\(filename)]\nUnable to download file.")
            }
        }
    }
    
    private func upload(data: Data, file: String, ext: String, to path: String, completion: @escaping UploadCompletion) {
        let filename = "\(path)/\(file).\(ext)"
        let reference = Storage.storage().reference().child(filename)
        reference.putData(data) { meta, error in
            if let error = error {
                completion("[\(filename)]\n\(error.localizedDescription)")
            } else {
                completion(nil)
            }
        }
    }
    
    private func associateDescriptions() {
        for research in researches {
            research.text = descriptions[research.name] ?? "ERROR"
        }
    }
    
    private func associateResarch() {
        for group in researchGroups {
            for research in researches {
                if group.research.contains(where: { $0.name == research.name }) {
                    group.associateResearch(research)
                }
            }
        }
    }
    
    private func fetchCharacters() {
        guard let uid = user?.uid else { return }
        let directory = "character/\(uid)"
        
        step = "Fetching characters..."
        isWorking.toggle()
        Storage.storage().reference().child(directory).listAll { result, error in
            if let error = error {
                self.error = error
            } else if let result = result {
                if result.items.isEmpty {
                    self.isWorking.toggle()
                } else {
                    let group = DispatchGroup()
                    
                    for file in result.items {
                        group.enter()
                        self.download(file: file.fullPath) { object, error in
                            if let error = error {
                                self.error = error
                            } else if let object = object {
                                let character = VaultCharacter(from: object)
                                if !self.characters.contains(character) {
                                    self.characters.append(character)
                                }
                            } else {
                                self.error = "Unable to download file at \(file.fullPath)."
                            }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.isWorking.toggle()
                    }
                }
            } else {
                self.error = "Could not fetch characters."
            }
        }
    }
    
    private func sync(in group: DispatchGroup) {
        // In case this fails at any point, we still want the DispatchGroup to complete,
        // so we'll enter and leave real quick to force an update.
        group.enter()
        group.leave()
        
        #warning("TODO: Sync files from bundle with Firebase!")
    }
}

// MARK: - Analytics/Crashlytics Support
extension FirebaseManager {
    static func report(error: String?, file: String = #file, function: String = #function, line: Int = #line) {
        if let error = error {
            print("TAG: registering error to Firebase: \(error), \(file), \(function), \(line)...")
            Crashlytics.crashlytics().log("\(error), \(file), \(function), \(line)")
        }
    }
}
