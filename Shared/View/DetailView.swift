//
//  DetailView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/3/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var isShown: Bool
    @Binding var title: String
    @Binding var text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.gray.opacity(0.5))
                .onTapGesture {
                    isShown.toggle()
                }
            
            RaisedPanel {
                VStack(alignment: .leading) {
                    HStack {
                        CircleButton(image: Image(systemName: "xmark")) {
                            isShown.toggle()
                        }
                        .padding(.vertical, 2)
                        
                        Text(title)
                            .bold()
                    }
                    
                    Text(text)
                        .font(.caption)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            isShown: .constant(true),
            title: .constant("Test"),
            text: .constant("This is a test")
        )
        
        DetailView(
            isShown: .constant(true),
            title: .constant("More Chests"),
            text: .constant("Unlocks Metal Barrels, Iron Chest & Storage Overhaul mods\n\nAll of these three mods offer bigger chests and storage options without automation")
        )
    }
}
