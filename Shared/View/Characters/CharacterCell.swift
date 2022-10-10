//
//  CharacterCell.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import SwiftUI

struct CharacterCell: View {
    @ObservedObject var character: VaultCharacter
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        RaisedPanel {
            Text(character.name)
                .font(.title3)
                .bold()
            
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
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(
            character: VaultCharacter(
                name: "Test",
                with: [])
        )
    }
}
