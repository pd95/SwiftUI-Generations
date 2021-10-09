//
//  NewFontsDemo.swift
//  NewFontsDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI
import UIKit

struct NewFontsDemo: View {
    var body: some View {
        VStack {
            Text("SwiftUI fonts:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                VStack {
                    Text("largeTitle")
                        .font(.largeTitle)
                    Text("title")
                        .font(.title)
                    Text("title2")
                        .font(.title2)
                    Text("title3")
                        .font(.title3)
                }
                VStack {
                    Text("headline")
                        .font(.headline)
                    Text("callout")
                        .font(.callout)
                    Text("subheadline")
                        .font(.subheadline)
                    Text("body")
                        .font(.body)
                    Text("footnote")
                        .font(.footnote)
                    Text("caption")
                        .font(.caption)
                    Text("caption2")
                        .font(.caption2)
                }
            }
        }
        .padding()
    }
}

struct NewFontsDemo_Previews: PreviewProvider {
    static var previews: some View {
        NewFontsDemo()
    }
}
