//
//  StateObject.swift
//  StateObject
//
//  Created by Philipp on 23.08.21.
//

import SwiftUI
import Combine
import os.log

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.StateObject")
@propertyWrapper
struct StateObject<ObjectType>: DynamicProperty where ObjectType: ObservableObject {

    @State private var stateObject: [ObjectType] = []
    @ObservedObject private var object: ObjectType

    /// Creates a new state object with an initial wrapped value.
    ///
    /// You don’t call this initializer directly. Instead, declare a property
    /// with the `@StateObject` attribute in a ``SwiftUI/View``,
    ///
    /// - Parameter thunk: An initial value for the state object.
    @inlinable public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType) {
        if let object = _stateObject.wrappedValue.first {
            os_log("🟡 reinit StateObject wrappedValue with existing value")
            self._object = .init(wrappedValue: object)
        } else {
            os_log("🟡 init StateObject wrappedValue: executing thunk()")
            let object = thunk()
            self._object = .init(wrappedValue: object)
            self._stateObject.wrappedValue.append(object)
        }
        os_log("🟡 init StateObject wrappedValue %@", String(describing: self))
    }


    /// The underlying value referenced by the state object.
    public var wrappedValue: ObjectType {
        os_log("🟡 wrappedValue %@", String(describing: object))
        return object
    }

    /// A projection of the state object that creates bindings to its
    /// properties.
    public var projectedValue: ObservedObject<ObjectType>.Wrapper {
        os_log("🟡 projectedValue %@", String(describing: $object))
        return $object
    }
}
