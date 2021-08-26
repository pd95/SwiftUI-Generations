//
//  Color-extension.swift
//  Color-extension
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI
import UIKit

#if os(iOS)

/// A representation of a color that adapts to a given context.
///
/// This extension implement the new sematic colors introduced in iOS 15.
///
extension Color {
    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color.mint")
    static var mint: Color {
        Color(UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(red: 0, green: 199/255.0, blue: 190/255.0, alpha: 1)
            } else {
                return UIColor(red: 99/255.0, green: 230/255.0, blue: 226/255.0, alpha: 1)
            }
        }))
    }

    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color.red")
    static var teal: Color {
        Color(UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(red: 48/255.0, green: 176/255.0, blue: 199/255.0, alpha: 1)
            } else {
                return UIColor(red: 64/255.0, green: 200/255.0, blue: 224/255.0, alpha: 1)
            }
        }))
    }

    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color.cyan")
    static var cyan: Color {
        Color(UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(red: 50/255.0, green: 173/255.0, blue: 230/255.0, alpha: 1)
            } else {
                return UIColor(red: 100/255.0, green: 210/255.0, blue: 255/255.0, alpha: 1)
            }
        }))
    }

    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color.indigo")
    static var indigo: Color {
        Color(UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(red: 88/255.0, green: 86/255.0, blue: 214/255.0, alpha: 1)
            } else {
                return UIColor(red: 93/255.0, green: 92/255.0, blue: 230/255.0, alpha: 1)
            }
        }))
    }

    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color.brown")
    static var brown: Color {
        Color(UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(red: 162/255.0, green: 132/255.0, blue: 93.5/255.0, alpha: 1)
            } else {
                return UIColor(red: 172/255.0, green: 142/255.0, blue: 104/255.0, alpha: 1)
            }
        }))
    }
}

#endif

extension Color {
    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color(cgColor:)")
    public init(cgColor color: CGColor) {
        self = Color(UIColor(cgColor: color))
    }

    @available(iOS, introduced: 13, obsoleted: 15.0,
               message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.Color(uiColor:)")
    public init(uiColor color: UIColor) {
        self = Color(color)
    }

    /// A Core Graphics representation of the color, if available.
    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.Color.cgColor")
    public var cgColor: CGColor? {

        let mirror = Mirror(reflecting: self)

        // Handle linear RGB
        if let red = mirror.descendant("provider", "base", "linearRed") as? Float,
           let green = mirror.descendant("provider", "base", "linearGreen") as? Float,
           let blue = mirror.descendant("provider", "base", "linearBlue") as? Float,
           let alpha = mirror.descendant("provider", "base", "opacity") as? Float
        {
            return CGColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }

        // Handle P3
        if  String(describing: type(of: mirror.descendant("provider", "base")!)) == "DisplayP3",
            let red = mirror.descendant("provider", "base", "red") as? CGFloat,
            let green = mirror.descendant("provider", "base", "green") as? CGFloat,
            let blue = mirror.descendant("provider", "base", "blue") as? CGFloat,
            let alpha = mirror.descendant("provider", "base", "opacity") as? Float
        {
            let colorSpace = CGColorSpace(name: CGColorSpace.displayP3)
            return CGColor(colorSpace: colorSpace!,
                    components: [red, green, blue, CGFloat(alpha)])
        }

        // All dynamic colors using UIDynamicSystemColor or UIDynamicProviderColor
        // won't return a value
        return nil
    }
}
