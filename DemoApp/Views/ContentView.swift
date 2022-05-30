//
//  ContentView.swift
//  ContentView
//
//  Created by Philipp on 19.08.21.
//

#if canImport(SwiftUIShim)
import SwiftUIShim
#else
import SwiftUI
#endif

struct ContentView: View {

    enum Tab: Int, CaseIterable {
        case none
        case basic, asyncImage, stateObject, list

        @ViewBuilder
        var view: some View {
            switch self {
            case .basic:
#if os(iOS)
                BasicsDemo()
#else
                placeholder
#endif
            case .asyncImage:
#if os(iOS)
                AsyncImageDemo()
#else
                placeholder
#endif
            case .stateObject:
#if os(iOS)
                StateObjectDemo()
#else
                placeholder
#endif
            case .list:
#if os(iOS)
                ListDemo()
#else
                placeholder
#endif
            default:
                placeholder
            }
        }

        @ViewBuilder
        var label: some View {
            switch self {
            case .basic:
                Label("Basics", systemImage: "list.bullet")
            case .asyncImage:
                Label("Image", systemImage: "photo")
            case .stateObject:
                Label("State", systemImage: "house")
            case .list:
                Label("List", systemImage: "text.justify")
            default:
                Label("Unknown", systemImage: "questionmark")
            }
        }

        var placeholder: some View {
            label
                .font(.largeTitle)
                .macOnlyPadding()
                .fixedSize()
        }
    }

    @SceneStorage("mainTab") private var selectedTab: Tab = Tab.none

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases.dropFirst(), id: \.self) { tab in
                tab.view
                    .tabItem {
                        tab.label
                    }
                    .tag(tab)
            }
        }
        .macOnlyPadding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
