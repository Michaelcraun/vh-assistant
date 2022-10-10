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
//        ZStack {
//            Rectangle()
//                .ignoresSafeArea()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .foregroundColor(.secondary.opacity(0.25))
//                .edgesIgnoringSafeArea(.all)
            
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
//        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("Hello, World!")
            
            LoadingView(
                isShown: .constant(true),
                text: .constant("Delving the depths...")
            )
        }
//        .preferredColorScheme(.dark)
    }
}
