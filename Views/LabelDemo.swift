//
//  LabelDemo.swift
//  LabelDemo
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI

struct LabelDemo: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Labels in various styles:")
                .font(.headline)

            Label("Profile", systemImage: "person.circle")
            Label("Lightning", systemImage: "bolt.fill")

            Divider()
                .frame(maxWidth: 200)

            Label("Lightning", systemImage: "bolt.fill")
                //.labelStyle(.iconOnly)
                .labelStyle(IconOnlyLabelStyle())
            Label("Lightning", systemImage: "bolt.fill")
                //.labelStyle(.titleOnly)
                .labelStyle(TitleOnlyLabelStyle())

            HStack {
                Label("Rain", systemImage: "cloud.rain")
                Label("Snow", systemImage: "snow")
                Label("Sun", systemImage: "sun.max")
            }
            //.labelStyle(.iconOnly)
            .labelStyle(IconOnlyLabelStyle())

            Label {
                Text("Philipp")
                    .font(.body)
                    .foregroundColor(.primary)
                Text("iOS Engineer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } icon: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 44, height: 44, alignment: .center)
                    .overlay(Text("PD"))
            }
        }
    }
}

struct LabelDemo_Previews: PreviewProvider {
    static var previews: some View {
        LabelDemo()
    }
}
