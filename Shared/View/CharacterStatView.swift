//
//  CharacterStatView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import SwiftUI

struct CharacterStatView: View {
    @ObservedObject var character: VaultCharacter
    var onStatAdjustment: () -> Void
    
    var body: some View {
        RaisedPanel {
            Spacer()
            
            // Knowledge Points
            VStack(spacing: 12) {
                Image("knowledge")
                    .frame(width: 30, height: 30)
                HStack {
                    CircleButton(image: Image(systemName: "chevron.down")) {
                        character.knowledgePoints -= 1
                        onStatAdjustment()
                    }
                    .disabled(character.knowledgePoints == 0)
                    
                    CircleButton(image: Image(systemName: "chevron.up")) {
                        character.knowledgePoints += 1
                        onStatAdjustment()
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
                        onStatAdjustment()
                    }
                    .disabled(character.skillPoints == 5)
                    
                    CircleButton(image: Image(systemName: "chevron.up")) {
                        character.skillPoints += 1
                        onStatAdjustment()
                    }
                }
                Text("\(character.skillPoints)")
            }
            
            Spacer()
        }
    }
}

struct CharacterStatView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterStatView(character: VaultCharacter(name: "Test", with: [])) {  }
    }
}
