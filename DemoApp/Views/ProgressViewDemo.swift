//
//  ProgressViewDemo.swift
//  ProgressViewDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUIShim

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
                } else if let endTime = endTime {
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
                progressObject.localizedDescription = withLabel ?
                    "\(progressObject.totalUnitCount - progressObject.completedUnitCount) files remaining..." :
                    nil
            }
            .onAppear(perform: {
                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            })

            Divider()

            VStack {
                Text("ProgressViewStyle testing")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    Text("Automatic Style")
                        .font(.headline)
                        .padding(.bottom)
                    ProgressView("Loading...")
                    ProgressView(value: progress/100)
                }
                .progressViewStyle(.automatic)

                Divider()

                Group {
                    Text("Forced Linear")
                        .font(.headline)
                        .padding(.bottom)
                    ProgressView("Loading...")
                    ProgressView(value: progress/100)
                }
                .progressViewStyle(.linear)

                Divider()

                Group {
                    Text("Forced Circular")
                        .font(.headline)
                        .padding(.bottom)
                    HStack {
                        ProgressView("Loading...")
                        ProgressView(value: progress/100)
                    }
                    .progressViewStyle(.circular)
                }

                Divider()

                Group {
                    Text("Custom styled progress")
                        .font(.headline)
                        .padding(.bottom)
                    ProgressView(value: progress/100,
                                 label: {Text("Loading...")})
                        .frame(width: 120, height: 120, alignment: .center)
                }
                .progressViewStyle(CustomProgressViewStyle())

                Divider()

                Group {
                    Text("Stacked progress view styles")
                        .font(.headline)
                        .padding(.bottom)
                    ProgressView(value: progress/100,
                                 label: {Text("Loading...").font(.title3)})
                        .progressViewStyle(DarkBlueShadowProgressViewStyle())
                }
                .progressViewStyle(YellowBackgroundProgressViewStyle())
            }
        }
        .padding()
    }
}

// Inspired by Prafulla Singh's article:
// https://prafullkumar77.medium.com/swiftui-how-to-make-circular-progress-view-97d32656c312
public struct CustomProgressViewStyle: ProgressViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 10) {
            configuration.label
                .foregroundColor(Color.secondary)
            ZStack {
                Circle()
                    .stroke(lineWidth: 15.0)
                    .opacity(0.3)
                    .foregroundColor(.accentColor.opacity(0.5))

                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .rotation(.degrees(-90))
                    .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.accentColor)

                Text("\(Int((configuration.fractionCompleted ?? 0) * 100))%")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// More custom styles from Apple documentation:
struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                    radius: 4.0, x: 1.0, y: 2.0)
    }
}

// ... and one "self grown":
struct YellowBackgroundProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding()
            .background(
                Color.yellow
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            )
    }
}

struct ProgressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
