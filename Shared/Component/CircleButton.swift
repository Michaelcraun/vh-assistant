//
//  CircleButton.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct CircleButton: View {
    var image: Image
    var action: () -> Void = {  }
    
    var body: some View {
        Button(action: action) {
            image
                .background {
                    Circle()
                        .stroke(Color.secondary, lineWidth: 1)
                        .overlay(Circle())
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .shadow(color: .secondary, radius: 0.5, x: 2, y: 2)
                }
                .padding(4)
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(image: Image(systemName: "chevron.up"))
    }
}
