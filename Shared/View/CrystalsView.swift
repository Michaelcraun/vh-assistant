//
//  CrystalsView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import SwiftUI

struct CrystalsView: View {
    var crystals: [Crystal]
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(crystals) { crystal in
                    RaisedPanel {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("crystal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                
                                Text("\(crystal.short) (\(crystal.modifiers.joined(separator: ", ")))")
                                
                                Spacer()
                            }
                            
                            Text(crystal.description)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle(Text("Crystals"))
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

struct CrystalsView_Previews: PreviewProvider {
    static var previews: some View {
        CrystalsView(crystals: [
            Crystal(
                short: "CRP",
                modifiers: [
                    "Copius",
                    "Rich",
                    "Plentiful"
                ],
                description: "Get more Larimar than you will ever need with 24x vault ore chance per ore generated in the vault!\n1. Find rooms with plenty of ores that spawn (mine, crystal cove)\n2. Waste most of your time in those rooms\n3. ????\n4. PROFIT!")
        ])
    }
}
