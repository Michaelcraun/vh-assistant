//
//  SettingsView.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import MessageUI
import SwiftUI

/* Settings List:
 - Change version (future)
 - Buy me a coffee
 */

struct SettingsView: View {
    @Binding var isShown: Bool
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    ScrollView {
                        SettingsButton(
                            title: "Contact us",
                            text: "Send us an email regarding any questions, conerns, or comments",
                            enabled: MFMailComposeViewController.canSendMail()) {
                                isShowingMailView.toggle()
                            }
                        
                        SettingsButton(
                            title: "Delete my playthroughs",
                            text: "Delete all playthroughs you currently have stored") {
                                #warning("TODO: Delete all characters")
                            }
                        
                        SettingsButton(
                            icon: "knowledge",
                            title: "Buy us a Knowledge Star",
                            text: "Make a small donation of \(0.99.localized()) to help us continue making awesome software") {
                                #warning("TODO: Store integration to charge 0.99 USD")
                            }
                    }
                }
                
                Text("This app is free, fan-made software. The creators of this app do not own or are affiliated with Minecraft or the Vault Huters mod pack.")
                    .font(.footnote)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Link(destination: URL(string: "https://www.mietechnologies.com")!) {
                    HStack {
                        Image("mietech")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text("Powered by MieTech, LLC")
                            .font(.custom("Futura", size: 16))
                    }
                    .foregroundColor(.primary)
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                }
                
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: $result)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isShown: .constant(true))
    }
}
