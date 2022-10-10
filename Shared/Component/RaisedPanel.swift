//
//  RaisedPanel.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct RaisedPanel<Content: View>: View {
    var spacing: CGFloat = 0.0
    @ViewBuilder var content: () -> Content
    
    private let color: Color = .secondary
    private let shadowColor: Color = .primary
    
    var body: some View {
        HStack(spacing: spacing) {
            content()
        }
        .padding(8)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(shadowColor.opacity(0.02))
        }
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(color.opacity(0.15))
                .shadow(color: shadowColor, radius: 2.0)
        }
        .padding(.horizontal, 8)
    }
}

struct RaisedPanel_Previews: PreviewProvider {
    static var previews: some View {
        RaisedPanel {
            Text("Hello, world!")
        }
        .previewLayout(.fixed(width: 300, height: 100))
        
        RaisedPanel {
            Text("Hello, world!")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
