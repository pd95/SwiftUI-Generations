//
//  SceneStorage.swift
//  SceneStorage
//
//  Created by Philipp on 29.08.21.
//

import SwiftUI

/// A protocol for types compatible which can be read from and written to a dictionnary of type [AnyHashable: Any]
public protocol PropertyListTransform {
    static func readValue(from store: [AnyHashable: Any], key: String, read: inout Bool) -> Any?
    static func writeValue(_ value: Any?, to store: inout [AnyHashable: Any], key: String)
}

// A default implementation of PropertyListTransformable
extension PropertyListTransform {
    public static func readValue(from store: [AnyHashable: Any], key: String, read: inout Bool) -> Any? {
        read = store.index(forKey: key) != nil
        return store[key]
    }

    public static func writeValue(_ value: Any?, to store: inout [AnyHashable: Any], key: String) {
        store[key] = value
    }
}

// The following types are known to be compatible with property lists
extension Bool: PropertyListTransform {}
extension Int: PropertyListTransform {}
extension Double: PropertyListTransform {}
extension String: PropertyListTransform {}
extension URL: PropertyListTransform {}
extension Data: PropertyListTransform {}

// For enums which are `RawRepresentable` use the `rawValue` for storing
private struct RawRepresentablePropertyListTransform<T>: PropertyListTransform where T: RawRepresentable, T.RawValue: PropertyListTransform {
    public static func readValue(from store: [AnyHashable: Any], key: String, read: inout Bool) -> Any? {
        if let rawValue = store[key] as? T.RawValue {
            return T(rawValue: rawValue)
        }
        return nil
    }

    public static func writeValue(_ value: Any?, to store: inout [AnyHashable: Any], key: String) {
        guard let value = value as? T? else { return }
        store[key] = value?.rawValue
    }
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.SceneStorage")
/// Helper class to get/set a value from a `[AnyHashable: Any]` dictionnary using the PropertyListTransform
private class AnyLocation<Value>: NSObject, ObservableObject
{
    private let key: String
    private let transform: PropertyListTransform.Type
    private let defaultValue: Value

    func get(from store: [AnyHashable: Any]) -> Value {
        var didRead = false
        let value = transform.readValue(from: store, key: key, read:&didRead) as? Value
        return value ?? defaultValue
    }

    func set(_ value: Value, to store: inout [AnyHashable: Any]) {
        self.objectWillChange.send()
        transform.writeValue(value, to: &store, key: key)
    }

    init(key: String, transform: PropertyListTransform.Type, defaultValue: Value) {
        self.key = key
        self.transform = transform
        self.defaultValue = defaultValue

        super.init()
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.SceneStorage")
/// A property wrapper type that represents a "named scene value" (managed by  the current `SceneManager`)
@propertyWrapper
public struct SceneStorage<Value>: DynamicProperty
{
    @EnvironmentObject private var sceneManager: SceneManager

    @ObservedObject private var location: AnyLocation<Value>

    public var wrappedValue: Value {
        get {
            location.get(from: sceneManager.valueStore)
        }
        nonmutating set {
            location.set(newValue, to: &sceneManager.valueStore)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding  { self.wrappedValue }
            set: { self.wrappedValue = $0 }
    }

    fileprivate init(key: String, transform: PropertyListTransform.Type, defaultValue: Value) {
        location = AnyLocation(key: key, transform: transform, defaultValue: defaultValue)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.SceneStorage")
extension SceneStorage {
    /// Creates a property that can read and write to a plain user default type.
    public init(wrappedValue: Value, _ key: String) where Value: PropertyListTransform {
        self.init(key: key, transform: Value.self, defaultValue: wrappedValue)
    }

    /// Creates a property that can read and write a scalar  user default, transforming that from and to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String) where Value: RawRepresentable, Value.RawValue: PropertyListTransform {
        self.init(key: key, transform: RawRepresentablePropertyListTransform<Value>.self, defaultValue: wrappedValue)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.SceneStorage")
extension SceneStorage where Value: ExpressibleByNilLiteral {
    /// Creates a property that can read and write an optional scalar user default.
    public init<WrappedType>(_ key: String) where Value == Optional<WrappedType>, WrappedType: PropertyListTransform {
        self.init(key: key, transform: WrappedType.self, defaultValue: nil)
    }

    /// Creates a property that can save and restore an optional value, transforming it to an optional `RawRepresentable` data type.
    public init<WrappedType>(_ key: String) where Value == Optional<WrappedType>, WrappedType: RawRepresentable, WrappedType.RawValue: PropertyListTransform {
        self.init(key: key, transform: RawRepresentablePropertyListTransform<WrappedType>.self, defaultValue: nil)
    }
}
