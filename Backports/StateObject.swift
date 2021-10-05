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

        private var cancellable: AnyCancellable?

        private var _object: ObjectType?
        var object: ObjectType {
            _object ?? reset()
        }

        var observedObject: ObservedObject<ObjectType> {
            ObservedObject(wrappedValue: object)
        }

        init(newObject: @escaping () -> ObjectType) {
            self.newObject = newObject
        }

        var hasObject: Bool {
            _object != nil
        }

        @discardableResult
        func reset(_ seed: Int = 0) -> ObjectType {
            if seed == 0 {
                os_log("🔴 StateObject.Storage.reset: executed with seed = 0. Is StateObject not in a view?")
            }

            // initialize a new instance
            let newObject = newObject()
            _object = newObject

            publish(to: objectWillChange)

            os_log("🟡 StateObject.Storage.reset: executed newObject() and relaying objectWillChange notifications ")
            return newObject
        }

        func synchronize(to otherStorage: Storage) {
            _object = otherStorage._object
            otherStorage.publish(to: objectWillChange)
        }

        private func publish(to targetPublisher: ObjectWillChangePublisher) {
            cancellable = object.objectWillChange
                .sink(receiveValue: { _ in
                    os_log("🟢 StateObject.Storage.publish: relaying objectWillChange notifications")
                    targetPublisher.send()
                })
        }
    }

    @State private var storage: Storage
    @ObservedObject private var observedStorage: Storage

    /// Creates a new state object with an initial wrapped value.
    ///
    /// You don’t call this initializer directly. Instead, declare a property
    /// with the `@StateObject` attribute in a ``SwiftUI/View``,
    ///
    /// - Parameter thunk: An initial value for the state object.
    public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType) {
        let storage = Storage(newObject: thunk)
        _storage = State(wrappedValue: storage)
        _observedStorage = ObservedObject(wrappedValue: storage)
        os_log("🟡 StateObject.init %@", String(describing: self))
    }

    /// The underlying value referenced by the state object.
    public var wrappedValue: ObjectType {
        // os_log("🟡 StateObject.wrappedValue %@", String(describing: self))
        return storage.object
    }

    /// A projection of the state object that creates bindings to its properties.
    public var projectedValue: ObservedObject<ObjectType>.Wrapper {
        // os_log("🟡 StateObject.projectedValue %@", String(describing: observedStorage))
        return storage.observedObject.projectedValue
    }

    // This function is called by SwiftUI to allow the DynamicProperty to take actions due to some "graph updates"
    public mutating func update() {
        os_log("🟡 StateObject.update %@", String(describing: self))

        // Forward update to our underlying property wrappers
        _storage.update()
        _observedStorage.update()

        // HACK! We rely on the internal _seed variable of `ObservedObject` to learn when we should call reset()
        let mirror = Mirror(reflecting: _observedStorage)
        guard let seed = mirror.descendant("_seed") as? Int else {
            return
        }

        // Initialize the storage if it has not been initialized so far or the `seed` has been "cleared"
        if seed == 1 || storage.hasObject == false {
            storage.reset(seed)
            os_log("🟡 StateObject.update: executed storage.reset() %@", String(describing: self))
        }

        // Whenever observedStorage has been reset, it gets disconnected from `storage` and needs synchronising
        if observedStorage.hasObject == false {
            os_log("🔴 StateObject.update: observedStorage needs synchronization with storage")
            dump(_observedStorage)
            observedStorage.synchronize(to: storage)
        }

        assert(observedStorage.object === storage.object,
            "Observed object and storage object must point to the same object!")
    }
}
