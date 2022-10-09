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
    
    var body: some View {
        HStack(spacing: spacing) {
            content()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.secondary, lineWidth: 1)
                .overlay(RoundedRectangle(cornerRadius: 5))
                .foregroundColor(.white)
                .shadow(color: .secondary, radius: 0.5, x: 2, y: 2)
        }
        .padding(.horizontal, 8)
    }
}

struct RaisedPanel_Previews: PreviewProvider {
    static var previews: some View {
        RaisedPanel {
            Text("Hello, world!")
        }
    }
}
