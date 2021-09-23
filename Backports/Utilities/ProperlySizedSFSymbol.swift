//
//  ProperlySizedSFSymbol.swift
//  iOS13-App
//
//  Created by Philipp on 23.09.21.
//

import SwiftUI

struct ProperlySizedSFSymbol: View {
    let name: String

    @State private var size: CGSize = .zero

    var body: some View {
        Color.clear
            .frame(width: size.width, height: size.height)
            .background(
                // Measure the bounds of the regular system image
                Image(systemName: name)
                    .anchorBounds(for: 2)
                    .background(
                        // Measure the bounds of the system image given by UIKit
                        Image(uiImage: UIImage(systemName: name) ?? UIImage())
                            .anchorBounds(for: 1)
                    )
                    .hidden()
            )
            .backgroundPreferenceValue(AnchorPreferenceKey.self) { preferences in
                // Use the current geometry and the measured bounds to calculate the new size of our view
                // based on the width of the regular system image and the proportions of the one returned by UIImage
                GeometryReader { geometry -> Color in
                    let boundsAnchorUIImage = preferences.boundsAnchor(for: 1)!
                    let boundsAnchorImage = preferences.boundsAnchor(for: 2)!
                    let newSize = CGSize(
                        width: geometry[boundsAnchorImage].width,
                        height: ceil(geometry[boundsAnchorUIImage].height/geometry[boundsAnchorUIImage].width*geometry[boundsAnchorImage].width)
                    )
                    if floor(newSize.height*10) != floor(size.height*10) {
                        DispatchQueue.main.async {
                            size = newSize
                        }
                    }

                    return Color.clear
                }
            }
            .overlay(
                // Draw our symbol as a simple overlay
                Image(systemName: name)
                    .padding(.top, 1)
            )
            .padding(.horizontal, 1)
    }
}
