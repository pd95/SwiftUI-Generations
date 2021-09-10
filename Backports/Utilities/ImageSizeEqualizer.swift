//
//  ImageSizeEqualizer.swift
//  ImageSizeEqualizer
//
//  Created by Philipp on 10.09.21.
//

import SwiftUI

/// Adjusts the size of an Image representing an SF Symbol
///
/// The goal is that the frame of the view covers all the symbol (not only the inner part as in iOS 13)
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Utility not necessary as of iOS 14")
struct ImageSizeEqualizer: View {
    @State private var minHeight: CGFloat = 0

    let image: Image

    var body: some View {
        image
            .frame(minWidth: minHeight, minHeight: minHeight, alignment: .center)
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewGeometryPreferenceKey.self, value: proxy.frame(in: .local))
            })
            .onPreferenceChange(ViewGeometryPreferenceKey.self, perform: { newValue in
                let largestSide = max(newValue.size.width + 1.5, newValue.size.height + 1)
                print(newValue.size)
                if largestSide != minHeight {
                    minHeight = largestSide
                }
            })
            .transition(.identity)
    }
}
