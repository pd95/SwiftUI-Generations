//
//  ContentView.swift
//  ContentView
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 3

    var body: some View {
        TabView(selection: $selectedTab) {
            BasicStuff()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(1)

            AsyncImageDemo()
                .tabItem {
                    Label("Image", systemImage: "photo")
                }
                .tag(2)

            StateObjectDemo()
                .tabItem {
                    Label("Main", systemImage: "house")
                }
                .tag(3)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
