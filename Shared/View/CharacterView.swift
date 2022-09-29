//
//  Character.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CharacterView: View {
    @StateObject var character: VaultCharacter
    @ObservedObject var database: Database
    
    var body: some View {
        VStack {
            RaisedPanel {
                Spacer()
                
                // Knowledge Points
                VStack(spacing: 12) {
                    Image(gif: "knowledge")
                        .frame(width: 30, height: 30)
                    CircleButton(image: Image(systemName: "chevron.up")) {
                        character.knowledgePoints += 1
                    }
                    Text("\(character.knowledgePoints)")
                }
                
                Spacer()
                
                // Skill Points
                VStack(spacing: 12) {
                    Image(gif: "skill")
                        .frame(width: 30, height: 30)
                    CircleButton(image: Image(systemName: "chevron.up")) {
                        character.skillPoints += 1
                    }
                    Text("\(character.skillPoints)")
                }
                
                Spacer()
            }
            
            ScrollView {
                ForEach(database.researchGroups.sorted()) { group in
                    RaisedPanel {
                        VStack {
                            HStack(alignment: .center) {
                                Text(group.title)
                                    .font(.title)
                                Spacer()
                                #warning("TODO: Need to put actual modifier here...")
                                Text("+1")
                            }
                            
                            ForEach(group.research) { research in
                                HStack {
                                    Image(systemName: "xmark")
                                    Text("\(research.name) (\(research.current))")
                                    Spacer()
                                }
                                .padding(8)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle(character.name)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(character: VaultCharacter(name: "A Whole New World"), database: Database())
    }
}
