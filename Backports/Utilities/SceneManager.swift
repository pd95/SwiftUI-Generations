//
//  SceneManager.swift
//  SceneManager
//
//  Created by Philipp on 29.08.21.
//

import SwiftUI
import Combine


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
/// Manages the scene related storage (`SceneStorage`) and monitors its activity state
public class SceneManager: ObservableObject {

    // The `UIScene` associated with this manager
    private let scene: UIScene

    // The storage location for all `@SceneStorage` properties
    var valueStore: [AnyHashable: Any] = [:]

    // The cancellables used when setting up the scene activity monitoring
    private var cancellables = Set<AnyCancellable>()
    @Published var scenePhase = ScenePhase.inactive

    public init(_ scene: UIScene, store: [AnyHashable: Any]?) {
        print("🟢 SceneManager.init", "sceneIdentifier", scene.session.persistentIdentifier)
        self.scene = scene
        if let valueStore = store {
            print("🟢 valueStore restored:", valueStore)
            self.valueStore = valueStore
        } else {
            print("🟢 No valueStore restored")
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
        default:
            scenePhase = .background
        }

        print("🟢 Scene activity notification: \(notification.name.rawValue) => scenePhase:", scenePhase)
    }

    public func saveState(in activity: NSUserActivity) {
        activity.addUserInfoEntries(from: valueStore)
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
            .environmentObject(sceneManager)
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
