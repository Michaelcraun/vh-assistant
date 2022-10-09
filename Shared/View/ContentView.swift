//
//  ContentView.swift
//  Shared
//
//  Created by Michael Craun on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = FirebaseManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    #if DEBUG
                    Button("Crash") {
                        fatalError("Debug crash was triggered")
                    }
                    .foregroundColor(.red)
                    #endif
                    
                    CharacterList(database: manager)
                }
                
                if manager.isWorking {
                    LoadingView(
                        isShown: $manager.isWorking,
                        text: $manager.step
                    )
                }
            }
            .errorAlert(error: $manager.error)
        }
    }
    
    init() {        
        manager.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
