//
//  ContentView.swift
//  Shared
//
//  Created by Michael Craun on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = FirebaseManager()
    
    @State private var crystalsShown: Bool = false
    @State private var settingsShown: Bool = false
    
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
            .toolbar {
                HStack {
                    Button {
                        crystalsShown.toggle()
                    } label: {
                        Image("crystal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    Button {
                        settingsShown.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $crystalsShown) {
                CrystalsView(isShown: $crystalsShown, crystals: manager.crystals.sorted(by: { $0.short <= $1.short }))
            }
            .sheet(isPresented: $settingsShown) {
                SettingsView(isShown: $settingsShown, database: manager)
            }
        }
    }
    
    init() {
        StoreManager.askForRating()
        manager.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
