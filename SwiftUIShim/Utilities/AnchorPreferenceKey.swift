//
//  AnchorPreferenceKey.swift
//  SwiftUIShim-Tests
//
//  Created by Philipp on 23.09.21.
//

import SwiftUI

struct AnchorPreferenceData {
    let viewIdx: Int
    var bounds: Anchor<CGRect>?
    var points: [Anchor<CGPoint>] = []
}

struct AnchorPreferenceKey: PreferenceKey {
    typealias Value = [AnchorPreferenceData]

    static var defaultValue: [AnchorPreferenceData] = []

    static func reduce(value: inout [AnchorPreferenceData], nextValue: () -> [AnchorPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

extension Array where Element == AnchorPreferenceData {
    func boundsAnchor(for viewIdx: Int) -> Anchor<CGRect>? {
        first(where: { $0.viewIdx == viewIdx })?.bounds
    }
}

extension View {

    func anchorBounds(for viewIdx: Int) -> some View {
        anchorPreference(key: AnchorPreferenceKey.self, value: .bounds,
                         transform: { [AnchorPreferenceData(viewIdx: viewIdx, bounds: $0)] })
    }

    func anchorPoint(for viewIdx: Int, source: Anchor<CGPoint>.Source) -> some View {
        anchorPreference(key: AnchorPreferenceKey.self, value: source,
                         transform: { [AnchorPreferenceData(viewIdx: viewIdx, points: [$0])] })
    }
}
