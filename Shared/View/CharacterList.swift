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
                        RaisedPanel {
                            Text(character.name)
                            Spacer()
                            VStack {
                                HStack {
                                    Text("Knowledge:")
                                    Text("\(character.knowledgePoints)")
                                }
                                HStack {
                                    Text("Skill:")
                                    Text("\(character.skillPoints)")
                                }
                            }
                            .font(.caption)
                        }
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
                    database.load(character: VaultCharacter(name: newPlaythroughName))
                }
                
                #if DEBUG
                database.new(character: VaultCharacter(name: "Test"))
                #endif
            })
        }, message: {
            Text("Message")
        })
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .navigationTitle("Playthroughs")
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        CharacterList(database: Database())
    }
}
