//
//  CharacterNameEntryView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import SwiftUI

struct CharacterNameEntryView: View {
    @Binding var isShown: Bool
    @Binding var name: String
    var completion: () -> Void
    
    @State var showErrorMessage: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.clear)
            
            RaisedPanel {
                VStack(alignment: .center) {
                    Text("Add Playthrough")
                        .bold()
                        .font(.title3)
                        .padding(4)
                    
                    Text("What name will you use for this playthrough?")
                    
                    TextField("Name", text: $name)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .shadow(color: .secondary, radius: 1.0)
                        }
                        .padding(8)
                    
                    Text("Name cannot be empty!")
                        .foregroundColor(showErrorMessage ? .red : .clear)
                    
                    HStack(spacing: 0) {
                        RaisedPanel {
                            Text("Cancel")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                        }
                        .onTapGesture {
                            isShown.toggle()
                            completion()
                            name = ""
                        }
                        
                        RaisedPanel {
                            Text("Add")
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: .infinity)
                        }
                        .onTapGesture {
                            if name == "" {
                                showErrorMessage = true
                            } else {
                                isShown.toggle()
                                completion()
                                name = ""
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CharacterNameEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterNameEntryView(
            isShown: .constant(true),
            name: .constant("Test")) {  }
            .preferredColorScheme(.dark)
    }
}
