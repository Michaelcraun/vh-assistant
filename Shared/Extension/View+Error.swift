//
//  View+Error.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/7/22.
//

import SwiftUI

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
    
    init(custom error: VHError) {
        underlyingError = error
    }
}

protocol VHError: LocalizedError {
    var localizedDescription: String? { get }
}

extension String: VHError {
    var localizedDescription: String? {
        return self
    }
}

extension String: Error {
    public var errorDescription: String? { self }
    public var recoverySuggestion: String? { "Please contact support" }
}

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
            let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
            return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
                Button(buttonTitle) {
                    error.wrappedValue = nil
                }
            } message: { error in
                Text(error.recoverySuggestion ?? "")
            }
        }
}
