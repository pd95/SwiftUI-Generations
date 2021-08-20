//
//  ProgressViewDemo.swift
//  ProgressViewDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct ProgressViewDemo: View {
    @State private var progress = 0.5

    var body: some View {
        VStack(spacing: 8) {
            Text("ProgressViews:")
                .font(.headline)

            ProgressView()
//            ProgressView()
//                .progressViewStyle(.linear)

            Divider()
                .frame(maxWidth: 200)

            ProgressView("Loading...")
//            ProgressView("Loading...")
//                .progressViewStyle(.linear)

            Divider()
                .frame(maxWidth: 200)


            VStack {
                ProgressView {
                    Text("Loading...")
                        .font(.title)
                        .bold()
                }
            }
            .padding()
            .border(.blue, width: 1)

            VStack {
//                ProgressView(value: progress)
//                    .progressViewStyle(.circular)
//
//                Divider()
//                    .frame(maxWidth: 200)

                ProgressView(value: progress)
                Button("More", action: {
                    progress = (progress + 0.05).truncatingRemainder(dividingBy: 1)
                })
            }
            .padding()
            .border(.blue, width: 1)
        }
    }
}

struct ProgressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
