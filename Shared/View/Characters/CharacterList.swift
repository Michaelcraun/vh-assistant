//
//  CharacterList.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CharacterList: View {
    @EnvironmentObject private var viewManager: ViewManager
    
    @ObservedObject var database: FirebaseManager
    @Binding var isAddingPlaythrough: Bool
    @Binding var newPlaythroughName: String
    
    var body: some View {
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
                        CharacterCell(character: character)
                            .onTapGesture {
                                database.currentCharacter = character
                            }
                    }
                }
                .padding(2)
            }
            
            Spacer()
            
            if database.currentCharacter != nil {
                NavigationLink(tag: database.currentCharacter!, selection: $database.currentCharacter) {
                    CharacterResearchView(
                        character: database.currentCharacter!,
                        database: database
                    )
                } label: {
                    EmptyView()
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
            ),
            isAddingPlaythrough: .constant(false),
            newPlaythroughName: .constant("")
        )
        .preferredColorScheme(.dark)
    }
}
