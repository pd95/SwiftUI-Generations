//
//  SceneDelegate.swift
//  DemoApp (iOS)
//
//  Created by Philipp on 19.08.21.
//

import os.log
import UIKit
#if canImport(SwiftUIShim)
import SwiftUIShim
#else
import SwiftUI
#endif

#if TARGET_IOS_MAJOR_13
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var sceneManager: SceneManager?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        // Initialize SceneManager instance and restore existing values
        let sceneManager = SceneManager(scene, store: session.stateRestorationActivity?.userInfo)
        self.sceneManager = sceneManager

        let contentView = ContentView()
            .sceneManager(sceneManager)  // Attach SceneManager to view hierarchy
            //.defaultAppStorage(UserDefaults(suiteName: "group.com.yourcompany.test")!)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        print(#function)

        // Create user activity and add existing scene storage values
        let activity = NSUserActivity(activityType: "com.yourcompany.sceneRestoration")
        sceneManager?.saveState(in: activity)
        return activity
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(#function)
        print("Continuing user activity", userActivity.activityType)
        print(userActivity)
    }
}

#endif
