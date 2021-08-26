//
//  AppStorage.swift
//  AppStorage
//
//  Created by Philipp on 26.08.21.
//

import SwiftUI
import Combine
import os.log

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
/// A property wrapper type that reflects a value from `UserDefaults` and
/// invalidates a view on a change in value in that user default.
@propertyWrapper
public struct AppStorage<Value>: DynamicProperty {

    @Environment(\.defaultAppStorage) private var defaultStore

    /// A wrapper class of ObservableObject to ensure SwiftUI is notified whan a value is set
    /// There is effectively no storage. All accesses are done with the given get() and set() methods.
    private class StorageWrapper<Value>: ObservableObject {

        var store: UserDefaults = .standard
        let get: (UserDefaults) -> Value
        let set: (UserDefaults, Value) -> Void

        init(get: @escaping (UserDefaults) -> Value, set: @escaping (UserDefaults, Value) -> Void) {
            self.get = get
            self.set = set
        }

        var wrappedValue: Value {
            get {
                self.get(store)
            }
            set {
                self.objectWillChange.send()
                self.set(store, newValue)
            }
        }

        var projectedValue: Binding<Value> {
            Binding(
                get: { self.wrappedValue },
                set: { self.wrappedValue = $0 }
            )
        }

    }

    @ObservedObject private var storage: StorageWrapper<Value>

    public var wrappedValue: Value {
        get {
            storage.wrappedValue
        }
        nonmutating set {
            storage.wrappedValue = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        storage.projectedValue
    }


    public mutating func update() {
        _storage.update()

        // Update storage with latest environment setting
        storage.store = defaultStore
    }
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage {

    /// Creates a property that can read and write to a boolean user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Bool {
        storage = StorageWrapper(get: { store in
            return (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to an integer user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Int {
        storage = StorageWrapper(get: { store in
            return (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to a double user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Double {
        storage = StorageWrapper(get: { store in
            return (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to a string user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == String {
        storage = StorageWrapper(get: { store in
            return (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to a url user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == URL {
        storage = StorageWrapper(get: { store in
            return (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to a user default as data.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Data {
        storage = StorageWrapper(get: { store in
            return (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to an integer user default,
    /// transforming that to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int {
        storage = StorageWrapper(get: { store in
            if let rawValue = store.object(forKey: key) as? Value.RawValue {
                return Value(rawValue: rawValue) ?? wrappedValue
            }
            return wrappedValue
        }, set: { store, newValue in
            store.set(newValue.rawValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to a string user default,
    /// transforming that to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        storage = StorageWrapper(get: { store in
            if let rawValue = store.object(forKey: key) as? Value.RawValue {
                return Value(rawValue: rawValue) ?? wrappedValue
            }
            return wrappedValue
        }, set: { store, newValue in
            store.set(newValue.rawValue, forKey: key)
        })
    }
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage where Value : ExpressibleByNilLiteral {

    /// Creates a property that can read and write an Optional boolean user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Bool? {
        storage = StorageWrapper(get: { store in
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional integer user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Int? {
        storage = StorageWrapper(get: { store in
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional double user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Double? {
        storage = StorageWrapper(get: { store in
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional string user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == String? {
        storage = StorageWrapper(get: { store in
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional URL user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == URL? {
        storage = StorageWrapper(get: { store in
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional data user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Data? {
        storage = StorageWrapper(get: { store in
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: { store, newValue in
            store.set(newValue, forKey: key)
        })
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage {

    /// Creates a property that can save and restore an Optional string,
    /// transforming it to an Optional `RawRepresentable` data type.
    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == String {
        storage = StorageWrapper(get: { store in
            if let rawValue = store.object(forKey: key) as? R.RawValue {
                return R(rawValue: rawValue)
            }
            return nil
        }, set: { store, newValue in
            store.set(newValue?.rawValue, forKey: key)
        })
    }

    /// Creates a property that can save and restore an Optional integer,
    /// transforming it to an Optional `RawRepresentable` data type.
    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == Int {
        storage = StorageWrapper(get: { store in
            if let rawValue = store.object(forKey: key) as? R.RawValue {
                return R(rawValue: rawValue)
            }
            return nil
        }, set: { store, newValue in
            store.set(newValue?.rawValue, forKey: key)
        })
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

