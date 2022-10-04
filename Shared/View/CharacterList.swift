//
//  CharacterList.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CharacterList: View {
    @ObservedObject var database: Database
    
    @State var isAddingPlaythrough: Bool = false
    @State var newPlaythroughName: String = ""
    
    var body: some View {
        VStack {
            RaisedPanel {
                Text("Add Playthrough")
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isAddingPlaythrough.toggle()
                    }
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(database.characters) { character in
                        NavigationLink(destination: CharacterResearchView(character: character, database: database)) {
                            RaisedPanel {
                                Text(character.name)
                                Spacer()
                                VStack(spacing: 2) {
                                    HStack {
                                        Image("knowledge")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                        Text("\(character.knowledgePoints)")
                                            .font(.caption)
                                    }
                                    HStack {
                                        Image("skill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                        Text("\(character.skillPoints)")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .foregroundColor(Color.black)
                    }
                }
                .padding(2)
            }
            
            Spacer()
        }
        .alert("Add Playthrough", isPresented: $isAddingPlaythrough, actions: {
            TextField("TextField", text: $newPlaythroughName)
            
            Button("Cancel", role: .cancel, action: {})
            Button("Add", action: {
                if !newPlaythroughName.isEmpty {
                    database.load(
                        character: VaultCharacter(
                            name: newPlaythroughName,
                            with: database.researchGroups
                        )
                    )
                }
                
                #if DEBUG
                database.new(
                    character: VaultCharacter(
                        name: "Test",
                        with: database.researchGroups
                    )
                )
                #endif
            })
        }, message: {
            Text("Message")
        })
        .navigationTitle("Playthroughs")
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        CharacterList(
            database: Database(
                with: [
                    VaultCharacter(
                        name: "Test",
                        with: Database().researchGroups
                    )
                ]
            )
        )
    }
}
