//
//  Character.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CharacterResearchView: View {
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
                                            title = research.name
                                            text = research.text
                                            isShowingDetail.toggle()
                                        }
                                        
                                        Spacer()
                                        
                                        CircleButton(image: Image(systemName: "checkmark")) {
                                            character.purchase(research: research)
                                        }
                                        .disabled(!character.canPurchase(research: research))
                                        .foregroundColor(research.purchased ? .green : character.canPurchase(research: research) ? .blue : .gray)
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
            
            if isShowingDetail {
                DetailView(isShown: $isShowingDetail, title: $title, text: $text)
            }
        }
        .navigationTitle(character.name)
        .onChange(of: character) { character in
            print(character.description)
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterResearchView(
            character: VaultCharacter(
                name: "A Whole New World",
                with: Database().researchGroups
            ),
            database: Database()
        )
    }
}
