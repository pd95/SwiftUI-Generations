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

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0, content: content)
    }
}
