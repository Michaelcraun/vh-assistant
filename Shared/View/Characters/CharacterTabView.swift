//
//  CharacterTabView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/3/22.
//

import SwiftUI

struct CharacterTabView: View {
    @StateObject var character: VaultCharacter
    @ObservedObject var database: FirebaseManager
    
    var body: some View {
        TabView {
            CharacterResearchView(character: character, database: database)
                .tabItem {
                    VStack {
                        Image("knowledge")
                        Text("Research")
                    }
                }
            
            CharacterSkillView(character: character, database: database)
                .tabItem {
                    VStack {
                        Image("skill")
                        Text("Skills")
                    }
                }
        }
    }
}

struct CharacterTabView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterTabView(
            character: VaultCharacter(
                name: "Test",
                with: FirebaseManager().researchGroups
            ),
            database: FirebaseManager()
        )
    }
}
