//
//  PlatformAdjustments.swift
//  DemoApp (iOS)
//
//  Created by Philipp on 30.05.22.
//

import SwiftUI

extension View {
    func macOnlyPadding() -> some View {
        self
    }
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}
