//
//  View-Never-body.swift
//  View-Never-body
//
//  Created by Philipp on 09.09.21.
//

import SwiftUI

#if SwiftUIv1
/// This extension allows us to create types conforming to `View` specifying a `Body` type of `Never`
extension View where Body == Swift.Never {
    public var body: Never {
        fatalError()
    }
}
#endif
