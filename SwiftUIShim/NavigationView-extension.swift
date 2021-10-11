//
//  NavigationView-extension.swift
//  NavigationView-extension
//
//  Created by Philipp on 25.08.21.
//

import SwiftUI

#if SwiftUIv1
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.View")
extension View {

    /// Sets the title and display mode in the navigation bar for this view.
    @inlinable public func navigationBarTitle<S>(
        _ title: S, displayMode: NavigationBarItem.TitleDisplayMode
    ) -> some View where S: StringProtocol {
        navigationBarTitle(Text(title), displayMode: displayMode)
    }

    /// Configures the view's title for purposes of navigation.
    @inlinable public func navigationTitle(_ title: Text) -> some View {
        navigationBarTitle(title)
    }

    /// Configures the view's title for purposes of navigation,
    @inlinable public func navigationTitle(_ titleKey: LocalizedStringKey) -> some View {
        navigationBarTitle(titleKey)
    }

    /// Configures the view's title for purposes of navigation, using a string.
    @inlinable public func navigationTitle<S>(_ title: S) -> some View where S: StringProtocol {
        navigationBarTitle(title)
    }
}
#endif
