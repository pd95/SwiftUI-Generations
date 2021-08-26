//
//  ProgressViewDemo.swift
//  ProgressViewDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct ProgressViewDemo: View {
    @State private var progress = 0.0

    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var endTime: Date?

    var body: some View {
        VStack(spacing: 8) {
            Text("ProgressViews:")
                .font(.headline)

            VStack {
                Text("Indeterminate progress")
                    .font(.subheadline)

                Divider()
                    .frame(maxWidth: 200)

                ProgressView()

                Divider()
                    .frame(maxWidth: 200)

                ProgressView("Loading...")

                Divider()
                    .frame(maxWidth: 200)

                ProgressView {
                    Text("Loading...")
                        .font(.title)
                        .bold()
                }
            }

            Divider()

            VStack {
                Text("Determinate progress")
                    .font(.subheadline)

                Divider()
                    .frame(maxWidth: 200)


                ProgressView(value: progress/100)

                Divider()
                    .frame(maxWidth: 200)

                ProgressView("Downloading…", value: progress, total: 100)

                Divider()
                    .frame(maxWidth: 200)

                VStack {
                    ProgressView(value: progress, total: 100, label: {
                        HStack {
                            Text("label :")
                            Image(systemName: "hourglass")
                                .rotationEffect(.degrees(360*4/100*progress))
                        }
                    }, currentValueLabel: {
                        Text("currentValueLabel: \(Int(progress))")
                    })
                }
            }
            .padding()
            .onReceive(timer) { time in
                if progress < 100 {
                    progress += 2
                }
                else if let endTime = endTime {
                    if endTime.distance(to: time) > 2 {
                        progress = 0
                        self.endTime = nil
                    }
                } else {
                    endTime = Date()
                }
            }
            .onAppear(perform: {
                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            })
        }
    }
}

struct ProgressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
