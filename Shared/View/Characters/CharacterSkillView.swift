//
//  CharacterSkillView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/4/22.
//

import SwiftUI

struct CharacterSkillView: View {
    @StateObject var character: VaultCharacter
    @ObservedObject var database: FirebaseManager
    
    @State var isShowingDetail: Bool = false
    @State var title: String = ""
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                CharacterStatView(character: character) {
                    database.save(character: character)
                }
                
                ScrollView {
                    
                }
            }
        }
    }
}

struct CharacterSkillView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSkillView(
            character: VaultCharacter(
                name: "A Whole New World",
                with: FirebaseManager().researchGroups
            ),
            database: FirebaseManager()
        )
    }
}
