//
//  SceneManager.swift
//  SceneManager
//
//  Created by Philipp on 29.08.21.
//

import SwiftUI
import Combine

#if TARGET_IOS_MAJOR_13
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
/// Manages the scene related storage (`SceneStorage`) and monitors its activity state
///
/// Must be integrated into your `SceneDelegate` as follows:
///
///        // A variable to keep a handle to the SceneManager responsible for this scene
///        var sceneManager: SceneManager?
///
///        func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
///                   options connectionOptions: UIScene.ConnectionOptions) {
///
///            // ... other scene initialization
///
///            // Create SceneManager instance and restore existing values
///            let sceneManager = SceneManager(scene, store: session.stateRestorationActivity?.userInfo)
///            self.sceneManager = sceneManager
///
///            // Attach SceneManager to view hierarchy
///            let contentView = ContentView()
///                .sceneManager(sceneManager)
///
///            // ... attach contentView to UIWindow
///
///        }
///
///        // Save current scene state in newly created state restoration activity
///        func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
///            // Create user activity and add existing scene storage values
///            let activity = NSUserActivity(activityType: "com.yourcompany.sceneRestoration")
///            sceneManager?.saveState(in: activity)
///            return activity
///        }
///
public class SceneManager: ObservableObject {

    // The `UIScene` associated with this manager
    private let scene: UIScene

    // The storage location for all `@SceneStorage` properties
    fileprivate let store: SceneStorageValues // swiftlint:disable:this private_over_fileprivate

    // The cancellables used when setting up the scene activity monitoring
    private var cancellables = Set<AnyCancellable>()
    @Published var scenePhase = ScenePhase.inactive

    public init(_ scene: UIScene, store: [AnyHashable: Any]?) {
        print("🟢 SceneManager.init", "sceneIdentifier", scene.session.persistentIdentifier)
        self.scene = scene
        if let valueStore = store {
            print("🟢 valueStore restored:", valueStore)
            self.store = SceneStorageValues(valueStore)
        } else {
            print("🟢 No valueStore restored")
            self.store = SceneStorageValues()
        }

        // Make sure we get notified of any kind of changes to the UIScene
        NotificationCenter.default.publisher(for: UIScene.willConnectNotification)
            .sink(receiveValue: updateScenePhase)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification)
            .sink(receiveValue: updateScenePhase)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification)
            .sink(receiveValue: updateScenePhase)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIScene.didActivateNotification)
            .sink(receiveValue: updateScenePhase)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)
            .sink(receiveValue: updateScenePhase)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIScene.didEnterBackgroundNotification)
            .sink(receiveValue: updateScenePhase)
            .store(in: &cancellables)
    }

    private func updateScenePhase(_ notification: Notification) {

        switch notification.name {
        case UIScene.didActivateNotification:
            scenePhase = .active
        case UIScene.willEnterForegroundNotification, UIScene.willDeactivateNotification:
            scenePhase = .inactive
        case UIScene.didEnterBackgroundNotification:
            scenePhase = .background
        default:
            break
        }

        print("🟢 Scene activity notification: \(notification.name.rawValue) => scenePhase:", scenePhase)
    }

    public func saveState(in activity: NSUserActivity) {
        activity.addUserInfoEntries(from: store.values)
        print("🟢 Saved scene state in activity")
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
/// A view modifier used to inject the current `ScenePhase` (monitored by the `SceneManager` object)
private struct SceneManagerViewModifier: ViewModifier {
    @ObservedObject var sceneManager: SceneManager

    func body(content: Content) -> some View {
        content
            .environment(\.scenePhase, sceneManager.scenePhase)
            .environment(\.sceneStorageValues, sceneManager.store)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension View {
    /// The `SceneManager` instance used by `SceneStorage` and `ScenePhase` contained within the view hierarchy.
    public func sceneManager(_ sceneManager: SceneManager) -> some View {
        return self
            .modifier(SceneManagerViewModifier(sceneManager: sceneManager))
    }
}
#endif
