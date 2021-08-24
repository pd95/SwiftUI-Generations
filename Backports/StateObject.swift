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

    private class Storage<ObjectType: ObservableObject>: ObservableObject {

        private var _object: ObjectType?
        private var _observedObject: ObservedObject<ObjectType>?
        private var cancellable: AnyCancellable?

        var object: ObjectType {
            get {
                guard let object = _object else {
                    fatalError("Storage has never been initialized")
                }
                return object
            }
            set {
                _object = newValue
                _observedObject = .init(initialValue: newValue)
                trackChanges()
            }
        }

        var observedObject: ObservedObject<ObjectType> {
            get {
                guard let observedObject = _observedObject else {
                    fatalError("Storage has never been initialized")
                }
                return observedObject
            }
        }

        func trackChanges() {
            print("⚫️ trackChanges()")
            cancellable = object.objectWillChange
                .sink(receiveValue: { _ in
                    self.objectWillChange.send()
                })
        }
    }

    @ObservedObject private var storage = Storage<ObjectType>()

    let initObject: () -> ObjectType

    /// Creates a new state object with an initial wrapped value.
    ///
    /// You don’t call this initializer directly. Instead, declare a property
    /// with the `@StateObject` attribute in a ``SwiftUI/View``,
    ///
    /// - Parameter thunk: An initial value for the state object.
    public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType) {
        initObject = thunk
        os_log("🟡 StateObject.init wrappedValue %@", String(describing: self))
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
        print("before", self)

        // FIXME: HACK! We rely on the internal _seed variable of `ObservedObject` which gets initialized to 1
        let mirror = Mirror(reflecting: _storage)
        for child in mirror.children {
            print(child)
            if child.label == "_seed" && child.value as? Int == 1 {
                let object = initObject()
                storage.object = object
                os_log("🟡 StateObject.update: executed initObject()", String(describing: self))
            }
        }
    }
}
