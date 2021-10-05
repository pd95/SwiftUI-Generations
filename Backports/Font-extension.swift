//
//  Font-extension.swift
//  Font-extension
//
//  Created by Philipp on 20.08.21.
//

import SwiftUI
import UIKit

extension Font {
    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Font.title2")
    static var title2: Font {
        let font = UIFont.preferredFont(forTextStyle: .title2)
        return Font(font)
    }

    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Font.title3")
    static var title3: Font {
        let font = UIFont.preferredFont(forTextStyle: .title3)
        return Font(font)
    }

    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Font.caption2")
    static var caption2: Font {
        let font = UIFont.preferredFont(forTextStyle: .caption2)
        return Font(font)
    }
}
