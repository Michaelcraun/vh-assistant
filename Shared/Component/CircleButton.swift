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
    
    private let color: Color = .secondary
    private let shadowColor: Color = .primary
    
    var body: some View {
        HStack {
            Button(action: action) {
                image
            }
        }
        .padding(8)
        .overlay {
            Circle()
                .strokeBorder(shadowColor.opacity(0.02))
        }
        .background {
            Circle()
                .fill(color.opacity(0.15))
                .shadow(color: shadowColor, radius: 2.0)
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(image: Image(systemName: "chevron.up"))
        .previewLayout(.fixed(width: 300, height: 100))
        
        CircleButton(image: Image(systemName: "chevron.up"))
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
