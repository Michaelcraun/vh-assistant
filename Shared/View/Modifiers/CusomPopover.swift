//
//  CusomPopover.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 10/10/22.
//

import SwiftUI

struct CustomPopover<Body:View>: ViewModifier {
    @Binding var isShown: Bool
    @ViewBuilder var body: () -> Body
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    if isShown {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(ThemeManager.element.background.opacity(0.5))
                            .overlay {
                                body()
                                    .transition(.opacity)
                            }
                    }
                }
                .animation(.default, value: isShown)
            }
    }
}

extension View {
    func customPopover<Body:View>(isShown: Binding<Bool>, @ViewBuilder body: @escaping () -> Body) -> some View {
        modifier(CustomPopover(isShown: isShown, body: body))
    }
}
