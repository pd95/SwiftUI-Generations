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
public protocol UserDefaultsValueTransform {
    static func readValue(from store: UserDefaults, key: String) -> Any?
    static func writeValue(_ value: Any?, to store: UserDefaults, key: String)
}

// Default implementation protocol
extension UserDefaultsValueTransform {
    public static func readValue(from store: UserDefaults, key: String) -> Any? {
        store.value(forKey: key)
    }

    public static func writeValue(_ value: Any?, to store: UserDefaults, key: String) {
        store.set(value as? Self, forKey: key)
    }
}

// The following types are known to be compatible with UserDefaults
extension Bool: UserDefaultsValueTransform {}
extension Int: UserDefaultsValueTransform {}
extension Double: UserDefaultsValueTransform {}
extension String: UserDefaultsValueTransform {}
extension URL: UserDefaultsValueTransform {
    public static func readValue(from store: UserDefaults, key: String) -> Any? {
        store.url(forKey: key)
    }

    public static func writeValue(_ value: Any?, to store: UserDefaults, key: String) {
        store.set(value as? Self, forKey: key)
    }
}
extension Data: UserDefaultsValueTransform {}


// For enums which are `RawRepresentable` use the `rawValue` for storing in `UserDefaults`
struct RawRepresentableTransform<T>: UserDefaultsValueTransform where T: RawRepresentable, T.RawValue: UserDefaultsValueTransform {
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
    private let transform: UserDefaultsValueTransform.Type
    private let defaultValue: Value
    private var cachedValue: Value?

    var store: UserDefaults {
        didSet {
            if oldValue != store {
                oldValue.removeObserver(self, forKeyPath: key)
                store.addObserver(self, forKeyPath: key, options: [], context: nil)
            }
        }
    }

    func get() -> Value {
        if let value = cachedValue {
            return value
        }
        let value = transform.readValue(from: store, key:key) as? Value ?? defaultValue
        cachedValue = value

        return value
    }

    func set(_ newValue: Value) {
        cachedValue = newValue
        transform.writeValue(newValue, to: store, key: key)
    }

    init(key: String, transform: UserDefaultsValueTransform.Type, store: UserDefaults?, defaultValue: Value) {
        self.key = key
        self.transform = transform
        self.store = store ?? .standard
        self.defaultValue = defaultValue

        super.init()

        self.store.addObserver(self, forKeyPath: key, options: [], context: nil)
    }

    deinit {
        store.removeObserver(self, forKeyPath: key)
    }

    // Called whenever the related UserDefaults value changed
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        self.objectWillChange.send()
        cachedValue = nil
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

    fileprivate init(key: String, transform: UserDefaultsValueTransform.Type, store: UserDefaults?, defaultValue: Value) {
        location = UserDefaultLocation(key: key, transform: transform, store: store, defaultValue: defaultValue)
    }

    public mutating func update() {
        _location.update()

        // Update storage with latest environment setting
        location.store = defaultStore
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage {
    /// Creates a property that can read and write to a plain user default type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value: UserDefaultsValueTransform {
        self.init(key: key, transform: Value.self, store: store, defaultValue: wrappedValue)
    }

    /// Creates a property that can read and write a scalar  user default, transforming that from and to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value: RawRepresentable, Value.RawValue: UserDefaultsValueTransform {
        self.init(key: key, transform: RawRepresentableTransform<Value>.self, store: store, defaultValue: wrappedValue)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage where Value: ExpressibleByNilLiteral {
    /// Creates a property that can read and write an optional scalar user default.
    public init<WrappedType>(_ key: String, store: UserDefaults? = nil) where Value == Optional<WrappedType>, WrappedType: UserDefaultsValueTransform {
        self.init(key: key, transform: WrappedType.self, store: store, defaultValue: nil)
    }

    /// Creates a property that can save and restore an optional value, transforming it to an optional `RawRepresentable` data type.
    public init<WrappedType>(_ key: String, store: UserDefaults? = nil) where Value == Optional<WrappedType>, WrappedType: RawRepresentable, WrappedType.RawValue: UserDefaultsValueTransform {
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

