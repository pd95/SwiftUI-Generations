//
//  SceneDelegate.swift
//  iOS13-App
//
//  Created by Philipp on 19.08.21.
//

import os.log
import UIKit
import SwiftUIShim

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var sceneManager: SceneManager?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene scene.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new
        // (see `application:configurationForConnectingSceneSession` instead).
        print(#function)

        // Initialize SceneManager instance and restore existing values
        let sceneManager = SceneManager(scene, store: session.stateRestorationActivity?.userInfo)
        self.sceneManager = sceneManager

        let contentView = ContentView()
            .sceneManager(sceneManager)  // Attach SceneManager to view hierarchy
            .defaultAppStorage(UserDefaults(suiteName: "group.com.yourcompany.test")!)

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
