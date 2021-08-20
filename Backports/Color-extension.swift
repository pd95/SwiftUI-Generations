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

#if DEBUG

// MARK: - Preview for testing
struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                Group {
                    Color.mint
                    Color.teal
                    Color.cyan
                    Color.indigo
                    Color.brown
                }
                .frame(width: 50, height: 50)
            }
            HStack(spacing: 2) {
                Group {
                    Color.mint
                    Color.teal
                    Color.cyan
                    Color.indigo
                    Color.brown
                }
                .frame(width: 50, height: 50)
            }
            .environment(\.colorScheme, .dark)
        }
    }
}

#endif
