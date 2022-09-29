//
//  ImageExtension.swift
//  VH Assistant
//
//  Created by Michael Craun on 9/29/22.
//

import SwiftUI

extension Image {
    init(gif named: String) {
        if let uiImage = UIImage.gif(asset: named) {
            self = Image(uiImage: uiImage)
        } else {
            self.init(systemName: "xmark")
        }
    }
}
