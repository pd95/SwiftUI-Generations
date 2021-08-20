//
//  ProgressViewDemo.swift
//  ProgressViewDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct ProgressViewDemo: View {
    @State private var progress = 0.0

    let startTime = Date()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

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

                ProgressView(value: progress/100)
            }
            .padding()
            .border(.blue, width: 1)

            VStack {
                ProgressView("Downloading…", value: progress, total: 100)
            }
            .padding()
            .border(.blue, width: 1)
            .onReceive(timer) { time in
                if progress < 100 {
                    progress += 2
                }
                if floor(startTime.distance(to: time)
                            .truncatingRemainder(dividingBy: 10)) == 0 {
                    progress = 0
                }
            }
        }
    }
}

struct ProgressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
