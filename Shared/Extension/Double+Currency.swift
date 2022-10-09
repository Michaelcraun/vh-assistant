//
//  Double+Currency.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import Foundation

extension Double {
    func localized() -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        guard let formatted = formatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        return formatted
    }
}
