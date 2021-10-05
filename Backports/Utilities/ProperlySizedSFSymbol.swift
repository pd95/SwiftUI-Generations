//
//  ProperlySizedSFSymbol.swift
//  iOS13-App
//
//  Created by Philipp on 23.09.21.
//

import SwiftUI

/// On iOS13 the SF Symbol images (load using `Image(systemName:)` are not properly reporting their size.
/// The area reported covers only the "cap height" (baseline up to top of uppercase letter) of a Text glyph. This
/// means that when you draw a background behind an SFSymbol you will only cover a small part of the symbol.
/// To fix this, the following view has been created.
///
/// The basic idea is to measure the (capped) size of the regular image, overlay it with a resizable version of the same
/// image and measure this (now not constrained) size. Based on the effective Symbol size we create a "clear" color view
/// which serves as the background of our `ZStack` onto which we are overlaying the symbol
struct ProperlySizedSFSymbol: View {
    let name: String

    @State private var rect1: CGRect = .zero
    @State private var rect2: CGRect = .zero

    var body: some View {
        ZStack(alignment: .center) {

            // Background view defining the effective view size
            Color.clear
                .frame(width: rect2.size.width, height: rect2.size.height)

            // The (capped) symbol view, overlaid with a resizable symbol
            let symbol = Image(systemName: name)
            symbol
                .anchorBounds(for: 1)
                .hidden()
                .background(
                    symbol
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .anchorBounds(for: 2)
                )
        }
        .backgroundPreferenceValue(AnchorPreferenceKey.self) { preferences in
            // Use the current geometry and the measured bounds to calculate the new size of our view (in rect2)
            GeometryReader { geometry -> Color in
                let boundsAnchorImage1 = preferences.boundsAnchor(for: 1)!
                let boundsAnchorImage2 = preferences.boundsAnchor(for: 2)!

                let rect1 = geometry[boundsAnchorImage1]
                let rect2 = geometry[boundsAnchorImage2]

                if rect1.height != self.rect1.height {
                    DispatchQueue.main.async {
                        self.rect1 = rect1
                        self.rect2 = rect2
                    }
                }

                return Color.clear
            }
        }
        .alignmentGuide(.firstTextBaseline, computeValue: { _ in
            return rect1.height - rect2.origin.y
        })
        .alignmentGuide(.lastTextBaseline, computeValue: { _ in
            return rect1.height - rect2.origin.y
        })
    }
}
