//
//  View-onChange.swift
//  View-onChange
//
//  Created by Philipp on 25.08.21.
//

import SwiftUI
import Combine

extension View {
    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.View.onChange")
    public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable {
        ValueChangeDetectionWrapper(value: value, action: action, content: self)
    }
}

private struct ValueChangeDetectionWrapper<V: Equatable, Content: View>: View {

    @State private var previousValue: V

    let value: V
    let action: (V) -> Void
    let content: Content

    init(value: V, action: @escaping (V) -> Void, content: Content) {
        self.value = value
        self.action = action
        self.content = content
        _previousValue = .init(wrappedValue: value)
    }

    var body: some View {
        return content
            .onReceive(Just(value).filter({ $0 != previousValue })) { newValue in
                previousValue = newValue
                action(newValue)
            }
    }

}

#if DEBUG
struct View_onChange_Previews: PreviewProvider {
    static var previews: some View {
        ViewOnChangeDemo()
    }
}
#endif
