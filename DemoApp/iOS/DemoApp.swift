//
//  DemoApp.swift
//  DemoApp (iOS)
//
//  Created by Philipp on 19.08.21.
//

import SwiftUIShim

#if TARGET_IOS_MAJOR_13

/// iOS 13 uses the `AppDelegate` and `SceneDelegate` protocol to setup the initial scene
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        print(#function)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

#else

// iOS 14 and above are based on the `App` protocol and the `@main` annotation to setup the initial scene
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#endif
