//
//  ContentView.swift
//  ContentView
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            BasicStuff()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            AsyncImageDemo()
                .tabItem {
                    Label("Image", systemImage: "photo")
                }
        }
    }
}

struct BasicStuff: View {
    var body: some View {
        ScrollView {
            VStack {
                NewColorsDemo()
                Divider()

                NewFontsDemo()
                Divider()

                LabelDemo()
                Divider()

                ProgressViewDemo()
                Spacer()
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
