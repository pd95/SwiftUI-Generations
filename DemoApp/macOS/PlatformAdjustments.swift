//
//  PlatformAdjustments.swift
//  DemoApp (macOS)
//
//  Created by Philipp on 30.05.22.
//

import SwiftUI

extension View {
    func macOnlyPadding() -> some View {
        self.padding()
    }
}
