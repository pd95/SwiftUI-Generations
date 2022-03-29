//
//  ContentView.swift
//  ContentView
//
//  Created by Philipp on 19.08.21.
//

import SwiftUIShim

struct ContentView: View {

    enum Tab: Int {
        case none
        case basic, asyncImage, stateObject, list
    }

    @SceneStorage("mainTab") private var selectedTab: Tab = Tab.none

    var body: some View {
        TabView(selection: $selectedTab) {
            BasicsDemo()
                .tabItem {
                    Label("Basics", systemImage: "list.bullet")
                }
                .tag(Tab.basic)

            AsyncImageDemo()
                .tabItem {
                    Label("Image", systemImage: "photo")
                }
                .tag(Tab.asyncImage)

            StateObjectDemo()
                .tabItem {
                    Label("State", systemImage: "house")
                }
                .tag(Tab.stateObject)

            ListDemo()
                .tabItem {
                    Label("List", systemImage: "text.justify")
                }
                .tag(Tab.list)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
