//
//  ProgressViewDemo.swift
//  ProgressViewDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct ProgressViewDemo: View {
    @Environment(\.scenePhase) var scenePhase

    @State private var withLabel = false
    @State private var progressObject = Progress()

    @State private var progress = 0.0

    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var endTime: Date?

    var body: some View {
        VStack(spacing: 8) {
            Text("ProgressViews:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                Text("Indeterminate progress")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)

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
                        .foregroundColor(.red)
                }
            }

            Divider()

            VStack {
                Text("Determinate progress")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)

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

                Divider()
                    .frame(maxWidth: 200)

                ProgressView(progressObject)
            }
            .onReceive(timer) { time in
                guard scenePhase == .active else {
                    return
                }
                if progress < 100 {
                    progress += 2
                }
                else if let endTime = endTime {
                    if endTime.distance(to: time) > 2 {
                        progress = 0
                        self.endTime = nil
                        withLabel.toggle()
                    }
                } else {
                    endTime = Date()
                }

                // Update Progress object accordingly
                progressObject.totalUnitCount = Int64(100*20)
                progressObject.completedUnitCount = Int64(progress*20)
                progressObject.localizedDescription = withLabel ? "\(progressObject.totalUnitCount - progressObject.completedUnitCount) files remaining..." : nil
            }
            .onAppear(perform: {
                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            })
        }
        .padding()
    }
}

struct ProgressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
