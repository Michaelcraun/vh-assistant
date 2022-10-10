//
//  ViewManager.swift
//  VH Assistant (iOS)
//
//  Created by Michael Craun on 10/10/22.
//

import SwiftUI

class ViewManager: ObservableObject {
    @Published var isShowingDetail: Bool = false
    @Published var detailTitle: String = ""
    @Published var detailText: String = ""
    
    @Published var isShowingNameEntry: Bool = false
    @Published var playthroughName: String = ""
    
    @Published var isShowingCrystals: Bool = false
    
    @Published var isShowingSettings: Bool = false
}
