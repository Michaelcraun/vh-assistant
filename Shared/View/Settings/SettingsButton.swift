//
//  SettingsButton.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import SwiftUI

struct SettingsButton: View {
    var icon: String? = nil
    var title: String
    var text: String
    var enabled: Bool = true
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            Button {
                onTap()
            } label: {
                RaisedPanel {
                    VStack(alignment: .leading) {
                        HStack {
                            if let icon = icon {
                                Image(icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text(title)
                                .bold()
                            
                            Spacer()
                        }
                        Text(text)
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .foregroundColor(enabled ? Color.primary : Color.secondary)
        .disabled(!enabled)
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SettingsButton(
                title: "Contact us",
                text: "Send us an email regarding any questions, conerns, or comments",
                enabled: false) {
                    
                }
            
            SettingsButton(
                title: "Delete my playthroughs",
                text: "Delete all playthroughs currently associated with your account") {
                    
                }
            
            SettingsButton(
                icon: "knowledge",
                title: "Buy us a Knowledge Star",
                text: "Make a small donation of \(0.99.localized()) to help us continue making awesome software") {
                    
                }
        }
    }
}
