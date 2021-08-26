//
//  ViewGeometryPreferenceKey.swift
//  ViewGeometryPreferenceKey
//
//  Created by Philipp on 23.08.21.
//

import SwiftUI

struct ViewGeometryPreferenceKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue().union(value)
    }
}
