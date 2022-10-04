//
//  CharacterSkillView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/4/22.
//

import SwiftUI

struct CharacterSkillView: View {
    @StateObject var character: VaultCharacter
    @ObservedObject var database: Database
    
    @State var isShowingDetail: Bool = false
    @State var title: String = ""
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                RaisedPanel {
                    Spacer()
                    
                    // Knowledge Points
                    VStack(spacing: 12) {
                        Image("knowledge")
                            .frame(width: 30, height: 30)
                        HStack {
                            CircleButton(image: Image(systemName: "chevron.down")) {
                                character.knowledgePoints -= 1
                            }
                            .disabled(character.knowledgePoints == 0)
                            
                            CircleButton(image: Image(systemName: "chevron.up")) {
                                character.knowledgePoints += 1
                            }
                        }
                        Text("\(character.knowledgePoints)")
                    }
                    
                    Spacer()
                    
                    // Skill Points
                    VStack(spacing: 12) {
                        Image("skill")
                            .frame(width: 30, height: 30)
                        HStack {
                            CircleButton(image: Image(systemName: "chevron.down")) {
                                character.skillPoints -= 1
                            }
                            .disabled(character.skillPoints == 5)
                            
                            CircleButton(image: Image(systemName: "chevron.up")) {
                                character.skillPoints += 1
                            }
                        }
                        Text("\(character.skillPoints)")
                    }
                    
                    Spacer()
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
                with: Database().researchGroups
            ),
            database: Database()
        )
    }
}
