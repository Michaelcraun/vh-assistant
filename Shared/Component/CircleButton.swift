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
        HStack {
            Button(action: action) {
                image
            }
        }
        .padding(8)
        .overlay {
            Circle()
                .strokeBorder(ThemeManager.element.border)
        }
        .background {
            Circle()
                .fill(ThemeManager.element.background)
                .shadow(color: ThemeManager.element.shadow, radius: 2.0)
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
