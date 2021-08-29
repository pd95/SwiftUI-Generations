//
//  ScenePhase.swift
//  ScenePhase
//
//  Created by Philipp on 29.08.21.
//

import SwiftUI

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ScenePhase")
public enum ScenePhase: Comparable, Hashable {
    /// The scene isn't currently visible in the UI.
    case background

    /// The scene is in the foreground but should pause its work.
    case inactive

    /// The scene is in the foreground and interactive.
    case active
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ScenePhase")
extension ScenePhase {
    init?(_ state: UIScene.ActivationState) {
        switch state {
        case .background:           self = .background
        case .foregroundActive:     self = .active
        case .foregroundInactive:   self = .inactive
        default:                    return nil
        }
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ScenePhase")
fileprivate struct ScenePhaseKey: EnvironmentKey {
    static var defaultValue: ScenePhase = .background
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ScenePhase")
extension EnvironmentValues {
    public var scenePhase: ScenePhase {
        get { self[ScenePhaseKey.self] }
        set { self[ScenePhaseKey.self] = newValue }
    }
}
