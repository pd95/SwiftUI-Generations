//
//  AppStorage.swift
//  AppStorage
//
//  Created by Philipp on 26.08.21.
//

import SwiftUI
import Combine
import os.log

/// A protocol for types compatible which can be read from and written to UserDefaults
public protocol UserDefaultsValueTransformable {
    static func readValue(from store: UserDefaults, key: String) -> Any?
    static func writeValue(_ value: Any?, to store: UserDefaults, key: String)
}


// Default implementation protocol
extension UserDefaultsValueTransformable {
    public static func readValue(from store: UserDefaults, key: String) -> Any? {
        store.value(forKey: key)
    }

    public static func writeValue(_ value: Any?, to store: UserDefaults, key: String) {
        store.setValue(value, forKey: key)
    }
}

// The following types are known to be compatible with UserDefaults
extension Bool: UserDefaultsValueTransformable {}
extension Int: UserDefaultsValueTransformable {}
extension Double: UserDefaultsValueTransformable {}
extension String: UserDefaultsValueTransformable {}
extension URL: UserDefaultsValueTransformable {}
extension Data: UserDefaultsValueTransformable {}


// For enums which are `RawRepresentable` use the `rawValue` for storing in `UserDefaults`
struct RawRepresentableTransform<T>: UserDefaultsValueTransformable where T: RawRepresentable, T.RawValue: UserDefaultsValueTransformable {
    public static func readValue(from store: UserDefaults, key: String) -> Any? {
        if let rawValue = store.value(forKey: key) as? T.RawValue {
            return T(rawValue: rawValue)
        }
        return nil
    }

    public static func writeValue(_ value: Any?, to store: UserDefaults, key: String) {
        guard let value = value as? T? else { return }
        store.setValue(value?.rawValue, forKey: key)
    }
}

/// Helper class to encapsulate the management of a single value: read/write, caching, UserDefaults KVO
private class UserDefaultLocation<Value>: NSObject, ObservableObject
{
    private let key: String
    private let transform: UserDefaultsValueTransformable.Type
    private let defaultValue: Value

    var defaultStore: UserDefaults {
        didSet {
            if oldValue != defaultStore {
                oldValue.removeObserver(self, forKeyPath: key)
                defaultStore.addObserver(self, forKeyPath: key, options: [], context: nil)
                wasRead = false
            }
        }
    }

    private var cachedValue: Value
    private var wasRead: Bool = false
    private var store: UserDefaults {
        defaultStore
    }

    func get() -> Value {
        if wasRead {
            return cachedValue
        }
        if let value = transform.readValue(from: store, key: key) as? Value {
            wasRead = true
            cachedValue = value
            return value
        }

        return defaultValue
    }

    func set(_ value: Value) {
        cachedValue = value
        transform.writeValue(value, to: store, key: key)
    }

    init(key: String, transform: UserDefaultsValueTransformable.Type, store: UserDefaults?, defaultValue: Value) {
        self.key = key
        self.transform = transform
        self.defaultStore = store ?? .standard
        self.defaultValue = defaultValue
        cachedValue = defaultValue

        super.init()

        self.defaultStore.addObserver(self, forKeyPath: key, options: [], context: nil)
    }

    deinit {
        defaultStore.removeObserver(self, forKeyPath: key)
    }

    // Called whenever the related UserDefaults value changed
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        self.objectWillChange.send()
        wasRead = false
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
/// A property wrapper type that reflects a value from `UserDefaults` and
/// invalidates a view on a change in value in that user default.
@propertyWrapper
public struct AppStorage<Value>: DynamicProperty
{
    @Environment(\.defaultAppStorage) private var defaultStore

    @ObservedObject private var location: UserDefaultLocation<Value>

    public var wrappedValue: Value {
        get {
            location.get()
        }
        nonmutating set {
            location.set(newValue)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding  { self.wrappedValue }
            set: { self.wrappedValue = $0 }
    }

    fileprivate init(key: String, transform: UserDefaultsValueTransformable.Type, store: UserDefaults?, defaultValue: Value) {
        location = UserDefaultLocation(key: key, transform: transform, store: store, defaultValue: defaultValue)
    }

    public mutating func update() {
        _location.update()

        // Update storage with latest environment setting
        location.defaultStore = defaultStore
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage {
    /// Creates a property that can read and write to a plain user default type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value: UserDefaultsValueTransformable {
        self.init(key: key, transform: Value.self, store: store, defaultValue: wrappedValue)
    }

    /// Creates a property that can read and write a scalar  user default, transforming that from and to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value: RawRepresentable, Value.RawValue: UserDefaultsValueTransformable {
        self.init(key: key, transform: RawRepresentableTransform<Value>.self, store: store, defaultValue: wrappedValue)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage where Value: ExpressibleByNilLiteral {
    /// Creates a property that can read and write an optional scalar user default.
    public init<WrappedType>(_ key: String, store: UserDefaults? = nil) where Value == Optional<WrappedType>, WrappedType: UserDefaultsValueTransformable {
        self.init(key: key, transform: WrappedType.self, store: store, defaultValue: nil)
    }

    /// Creates a property that can save and restore an optional value, transforming it to an optional `RawRepresentable` data type.
    public init<WrappedType>(_ key: String, store: UserDefaults? = nil) where Value == Optional<WrappedType>, WrappedType: RawRepresentable, WrappedType.RawValue: UserDefaultsValueTransformable {
        self.init(key: key, transform: RawRepresentableTransform<WrappedType>.self, store: store, defaultValue: nil)
    }
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension View {

    /// The default store used by `AppStorage` contained within the view.
    public func defaultAppStorage(_ store: UserDefaults) -> some View {
        return self.environment(\.defaultAppStorage, store)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
struct DefaultAppStorage: EnvironmentKey {
    static var defaultValue: UserDefaults = .standard
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.EnvironmentValues.AppStorage")
extension EnvironmentValues {
    fileprivate var defaultAppStorage: UserDefaults {
        get { self[DefaultAppStorage.self] }
        set { self[DefaultAppStorage.self] = newValue }
    }
}

