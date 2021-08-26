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
public struct StateObject<ObjectType>: DynamicProperty where ObjectType: ObservableObject {

    /// Storage object wrapping an `ObjectType` which may not yet been initialized (=Optional)
    ///
    /// (Re-)initialization happens upon first access or a call to `reset()`.
    /// All changes to the underlying object are republished as changes to this wrapper.
    private class Storage: ObservableObject {

        private var newObject: () -> ObjectType

        private var _object: ObjectType?
        private var subscriber: AnyCancellable?

        var object: ObjectType {
            _object ?? reset()
        }

        var observedObject: ObservedObject<ObjectType> {
            ObservedObject(wrappedValue: object)
        }

        init(newObject: @escaping () -> ObjectType) {
            self.newObject = newObject
        }

        @discardableResult
        func reset() -> ObjectType {
            // initialize a new instance
            let newObject = newObject()
            _object = newObject

            // Subscribe to its changes and republish them as our changes
            subscriber = newObject.objectWillChange
                .sink(receiveValue: { [weak self] _ in
                    self?.objectWillChange.send()
                })

            os_log("🟡 StateObject.Storage.reset > executed initObject()", String(describing: self))
            return newObject
        }
    }

    @ObservedObject private var storage: Storage

    /// Creates a new state object with an initial wrapped value.
    ///
    /// You don’t call this initializer directly. Instead, declare a property
    /// with the `@StateObject` attribute in a ``SwiftUI/View``,
    ///
    /// - Parameter thunk: An initial value for the state object.
    public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType) {
        _storage = ObservedObject(wrappedValue: Storage(newObject: thunk))
        os_log("🟡 StateObject.init %@", String(describing: self))
    }

    /// The underlying value referenced by the state object.
    public var wrappedValue: ObjectType {
        os_log("🟡 StateObject.wrappedValue %@", String(describing: storage.object))
        return storage.object
    }

    /// A projection of the state object that creates bindings to its
    /// properties.
    public var projectedValue: ObservedObject<ObjectType>.Wrapper {
        os_log("🟡 StateObject.projectedValue %@", String(describing: storage.observedObject))
        return storage.observedObject.projectedValue
    }

    // This function is called by SwiftUI to allow this DynamicProperty to take actions
    // due to some storage update (?)
    public mutating func update() {
        os_log("🟡 StateObject.update")
        _storage.update()

        // FIXME: HACK! We rely on the internal _seed variable of `ObservedObject` which gets initialized to 1
        let mirror = Mirror(reflecting: _storage)
        if let seed = mirror.descendant("_seed") as? Int, seed == 1 {
            storage.reset()
            os_log("🟡 StateObject.update: executed initObject()", String(describing: self))
        }
    }
}
