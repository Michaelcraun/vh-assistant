//
//  ContentView.swift
//  Shared
//
//  Created by Michael Craun on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewManager = ViewManager()
    @ObservedObject var manager = FirebaseManager()
    
    var body: some View {
        NavigationView {
            VStack {
                #if DEBUG
                Button("Crash") {
                    fatalError("Debug crash was triggered")
                }
                .foregroundColor(.red)
                #endif
                
                CharacterList(
                    database: manager,
                    isAddingPlaythrough: $viewManager.isShowingNameEntry,
                    newPlaythroughName: $viewManager.playthroughName
                )
            }
            .errorAlert(error: $manager.error)
            .toolbar {
                HStack {
                    Button {
                        viewManager.isShowingCrystals.toggle()
                    } label: {
                        Image("crystal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    Button {
                        viewManager.isShowingSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $viewManager.isShowingCrystals) {
                CrystalsView(
                    isShown: $viewManager.isShowingCrystals,
                    crystals: manager.crystals.sorted(by: { $0.short <= $1.short })
                )
            }
            .sheet(isPresented: $viewManager.isShowingSettings) {
                SettingsView(
                    isShown: $viewManager.isShowingSettings,
                    database: manager
                )
            }
        }
        .environmentObject(viewManager)
        .customPopover(isShown: $manager.isWorking) {
            LoadingView(
                isShown: $manager.isWorking,
                text: $manager.step
            )
        }
        .customPopover(isShown: $viewManager.isShowingNameEntry) {
            CharacterNameEntryView(
                isShown: $viewManager.isShowingNameEntry,
                name: $viewManager.playthroughName) {
                    if !viewManager.playthroughName.isEmpty {
                        manager.newCharacterWith(name: viewManager.playthroughName)
                    }
                }
        }
        .customPopover(isShown: $viewManager.isShowingDetail) {
            DetailView(
                isShown: $viewManager.isShowingDetail,
                title: $viewManager.detailTitle,
                text: $viewManager.detailText
            )
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
