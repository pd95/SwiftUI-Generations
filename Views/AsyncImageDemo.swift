//
//  AsyncImageDemo.swift
//  AsyncImageDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct AsyncImageDemo: View {
    let url = URL(string: "https://developer.apple.com/assets/elements/icons/xcode/xcode-128x128_2x.png")
    let urlHQ = URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Purple115/v4/ec/70/a6/ec70a6ff-fbbb-f924-0b05-cfa0028e3269/Xcode-85-220-0-4-2x.png/1024x0w.png")

    @State private var state1 = 2
    @State private var state2 = 1

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Loading images asynchronously:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()

                    Text("Image is clipped (as the original image is bigger than the available frame and it is `.resizable` cannot be attached.")
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.99)
                        .padding(.horizontal)

                    AsyncImage(url: url)
                        .frame(width: 100, height: 100)
                        .clipped()

                    Divider()

                    Text("Tap the images below for resize effect.")
                        .padding(.horizontal)


                    Text("This image is resizable with low-resolution")
                        .padding(.horizontal)
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: imageWidth(state1))
                    .onTapGesture {
                        withAnimation {
                            state1 += 1
                        }
                    }

                    Divider()

                    Text("This image is high-resolution (1024 pixels):\n(Turn your phone to appreciate it!)")

                    AsyncImage(url: urlHQ) { phase in
                        if let image = phase.image {
                            image // Displays the loaded image.
                                .resizable()
                        } else if phase.error != nil {
                            Color.red // Indicates an error.
                        } else {
                            Color.blue // Acts as a placeholder.
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: imageWidth(state2))
                    .onTapGesture {
                        withAnimation {
                            state2 += 1
                        }
                    }
                }
                .frame(minHeight: minScrollViewHeight, alignment: .top)
            }
            .navigationTitle("AsyncImage Demo")
        }
    }

    var minScrollViewHeight: CGFloat? {
        if #available(iOS 14, *) {
            return nil
        }
        else {
            // iOS 13 has a buggy ScrollView implementation which is bad at adapting dynamically
            return 500+(imageWidth(state2) ?? 0)+(imageWidth(state1) ?? 0)
        }
    }

    func imageWidth(_ state: Int) -> CGFloat? {
        let remainder = CGFloat(state % 4)
        if remainder == 0 {
            if #available(iOS 14, *) {
                return nil
            }
            else {
                return 400
            }
        }
        else {
            return 100.0 * remainder
        }
    }
}

struct AsyncImageDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageDemo()
    }
}
