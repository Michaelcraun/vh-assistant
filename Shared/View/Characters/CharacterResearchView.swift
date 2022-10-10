//
//  Character.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CharacterResearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var viewManager: ViewManager
    
    @StateObject var character: VaultCharacter
    @ObservedObject var database: FirebaseManager
    
    var body: some View {
        ZStack {
            VStack {
                CharacterStatView(character: character) {
                    database.save(character: character)
                }
                
                ScrollView {
                    ForEach(character.researches.sorted()) { group in
                        RaisedPanel {
                            VStack {
                                HStack(alignment: .center) {
                                    Text(group.title)
                                        .font(.title)
                                    Spacer()
                                    Text("\(group.modifier >= 1 ? "+\(group.modifier)" : "\(group.modifier)")")
                                }
                                
                                ForEach(group.research) { research in
                                    HStack {
                                        HStack {
                                            Image(research.name)
                                            Text("\(research.name) (\(research.current))")
                                        }
                                        .onTapGesture {
                                            print("TAG: showing detail for \(research.name) with text \(research.text)")
                                            viewManager.detailTitle = research.name
                                            viewManager.detailText = research.text
                                            viewManager.isShowingDetail.toggle()
                                        }
                                        
                                        Spacer()
                                        
                                        CircleButton(image: Image(systemName: "checkmark")) {
                                            character.purchase(research: research)
                                            database.save(character: character)
                                        }
                                        .disabled(!character.canPurchase(research: research))
                                        .foregroundColor(research.purchased ? .green : character.canPurchase(research: research) ? .blue : .secondary)
                                    }
                                    .padding(8)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle(character.name)
        .toolbar {
            HStack {
                Button {
                    database.delete(character: character)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "trash")
                }
                    
            }
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterResearchView(
            character: VaultCharacter(
                name: "A Whole New World",
                with: FirebaseManager().researchGroups
            ),
            database: FirebaseManager()
        )
    }
}
