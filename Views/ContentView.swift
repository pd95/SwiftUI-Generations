//
//  ContentView.swift
//  ContentView
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI

struct ContentView: View {
    let url = URL(string: "https://developer.apple.com/assets/elements/icons/xcode/xcode-128x128_2x.png")

    var body: some View {
        ScrollView {
            VStack {
                HStack(spacing: 0) {
                    Text("Light: ")
                    Group {
                        Color.mint
                        Color.teal
                        Color.cyan
                        Color.indigo
                        Color.brown
                    }
                    .frame(width: 50, height: 50)
                    .environment(\.colorScheme, .light)
                }
                HStack(spacing: 0) {
                    Text("Dark: ")
                    Group {
                        Color.mint
                        Color.teal
                        Color.cyan
                        Color.indigo
                        Color.brown
                    }
                    .frame(width: 50, height: 50)
                    .environment(\.colorScheme, .dark)
                }

                Group {
                    Label("Profile", systemImage: "person.circle")
                    Label("Lightning", systemImage: "bolt.fill")
                    Divider()
                    Label("Profile", systemImage: "person.circle")
                        .labelStyle(.iconOnly)
                    Label("Lightning", systemImage: "bolt.fill")
                        .labelStyle(.titleOnly)
                    Label("Profile", systemImage: "person.circle")
                        .labelStyle(.titleAndIcon)
                    Label("Lightning", systemImage: "bolt.fill")
                        .labelStyle(.automatic)
                }
                Divider()

                Group {
                    AsyncImage(url: url)
                        .frame(width: 100, height: 100)
                        .clipped()

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
                .overlay(RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.red, lineWidth: 4))
            }
            .accentColor(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
