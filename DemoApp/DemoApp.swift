//
//  DemoApp.swift
//  DemoApp
//
//  Created by Philipp on 19.08.21.
//

import SwiftUIShim

#if !TARGET_IOS_MAJOR_13
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#endif
