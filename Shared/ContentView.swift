//
//  ContentView.swift
//  Shared
//
//  Created by Michael Craun on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var database: Database = Database()
    
    var body: some View {
        NavigationView {
            CharacterList(database: database)
        }
    }
    
    init() {
        // Do any temporary testing setup here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
