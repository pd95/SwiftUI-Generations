//
//  ProgressViewDemo.swift
//  ProgressViewDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct ProgressViewDemo: View {
    @State static private var progress = 0.5

    var body: some View {
        VStack(spacing: 8) {
            Text("ProgressViews...")
                .font(.headline)

            ProgressView()

            ProgressView("Loading...")

            ProgressView {
                Text("Loading...")
                    .font(.title)
                    .bold()
            }

            /*
            VStack {
                ProgressView(value: progress)
                Button("More", action: { progress += 0.05 })
            }
             */
        }
    }
}

struct ProgressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
