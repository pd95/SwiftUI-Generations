//
//  Section-extension.swift
//  Section-extension
//
//  Created by Philipp on 29.03.22.
//

import SwiftUI

#if (TARGET_IOS_MAJOR_13 || TARGET_IOS_MAJOR_14)
@available(iOS, introduced: 13, obsoleted: 15.0,
           message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Section")
extension Section where Parent == Text, Content : View, Footer == EmptyView {

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(header: Text(titleKey), content: content)
    }

    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.init(header: Text(title), content: content)
    }
}
#endif
