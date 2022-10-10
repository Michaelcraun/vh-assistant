//
//  CharacterList.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CharacterList: View {
    @ObservedObject var database: FirebaseManager
    
    @State var isAddingPlaythrough: Bool = false
    @State var newPlaythroughName: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                RaisedPanel {
                    Text("Add Playthrough")
                        .bold()
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            isAddingPlaythrough.toggle()
                        }
                        .disabled(isAddingPlaythrough)
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(database.characters) { character in
                            NavigationLink(destination: CharacterResearchView(character: character, database: database)) {
                                CharacterCell(character: character)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .padding(2)
                }
                
                Spacer()
            }
            
            if isAddingPlaythrough {
                CharacterNameEntryView(isShown: $isAddingPlaythrough, name: $newPlaythroughName) {
                    if !newPlaythroughName.isEmpty {
                        database.newCharacterWith(name: newPlaythroughName)
                    }
                }
            }
        }
        .navigationTitle("Playthroughs")
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        CharacterList(
            database: FirebaseManager(
                with: [
                    VaultCharacter(
                        name: "Test",
                        with: FirebaseManager().researchGroups
                    )
                ]
            )
        )
    }
}
