//
//  RaisedPanel.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

struct RaisedPanel<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    var spacing: CGFloat = 0.0
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack(spacing: spacing) {
            content()
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(ThemeManager.element.background)
                .shadow(color: ThemeManager.element.shadow, radius: 2.0)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(ThemeManager.element.border))
        }
        .padding(.horizontal)
    }
}

struct RaisedPanel_Previews: PreviewProvider {
    static var previews: some View {
        RaisedPanel {
            Text("Hello, world!")
                .foregroundColor(ThemeManager.element.text)
        }
        .previewLayout(.fixed(width: 300, height: 100))
        
        RaisedPanel {
            Text("Hello, world!")
                .foregroundColor(ThemeManager.element.text)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
