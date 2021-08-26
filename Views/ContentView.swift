//
//  ContentView.swift
//  ContentView
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI

struct ContentView: View {

    enum Tab: Int {
        case none
        case basic, asyncImage, stateObject
    }

    @AppStorage("mainTab") private var selectedTab: Tab = Tab.none

    var body: some View {
        TabView(selection: $selectedTab) {
            BasicStuff()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.basic)

            AsyncImageDemo()
                .tabItem {
                    Label("Image", systemImage: "photo")
                }
                .tag(Tab.asyncImage)

            StateObjectDemo()
                .tabItem {
                    Label("Main", systemImage: "house")
                }
                .tag(Tab.stateObject)
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
