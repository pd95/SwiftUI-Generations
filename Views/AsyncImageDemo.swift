//
//  AsyncImageDemo.swift
//  AsyncImageDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct AsyncImageDemo: View {
    let url = URL(string: "https://developer.apple.com/assets/elements/icons/xcode/xcode-128x128_2x.png")

    var body: some View {
        VStack {
            Text("Loading images asynchronously...")
                .font(.headline)
            AsyncImage(url: url)
                .frame(width: 100, height: 100)
                .clipped()

            Text("Image is clipped (as the original image is bigger than the available frame and it is `.resizable` cannot be attached.")
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.99)
                .font(.caption)
                .padding(.horizontal)

            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)

            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                } else if phase.error != nil {
                    Color.red // Indicates an error.
                } else {
                    Color.blue // Acts as a placeholder.
                }
            }
        }
    }
}

struct AsyncImageDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageDemo()
    }
}
