//
//  VH_AssistantApp.swift
//  Shared
//
//  Created by Michael Craun on 9/28/22.
//

import SwiftUI
import Firebase

@main
struct VH_AssistantApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
