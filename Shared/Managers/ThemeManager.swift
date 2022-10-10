//
//  ThemeManager.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 10/10/22.
//

import SwiftUI

class ThemeManager {
    @Environment(\.colorScheme) private var colorScheme
    
    static let instance = ThemeManager()
    static var element: Element { Element() }
    
    struct Element {
        private var scheme: ColorScheme { ThemeManager.instance.colorScheme }
        
        var background: Color { Color(uiColor: .systemBackground) }
        var border: Color { ThemeManager.instance.colorScheme == .dark ? .white : .gray }
        var disabledText: Color { .gray }
        var shadow: Color { ThemeManager.instance.colorScheme == .dark ? .white : .gray }
        var text: Color { scheme == .dark ? .white : .black }
    }
    
    var primary: Color { colorScheme == .dark ? .black : .white }
    var secondary: Color { .gray }
    var tertiary: Color { colorScheme == .dark ? .white : .black }
}
