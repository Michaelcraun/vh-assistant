//
//  LoadingView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/6/22.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isShown: Bool
    @Binding var text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.secondary.opacity(0.1))
            
            RaisedPanel {
                VStack(alignment: .center) {
                    Text("Loading...")
                        .bold()
                    
                    Text(text)
                        .font(.caption)
                    
                    ProgressView()
                        .padding(4)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(
            isShown: .constant(true),
            text: .constant("Delving the depths...")
        )
//        .preferredColorScheme(.dark)
    }
}
