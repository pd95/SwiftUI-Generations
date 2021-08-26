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

    /// A wrapper class of ObservableObject to ensure SwiftUI is notified whan a value is set
    /// There is effectively no storage. All accesses are done with the given get() and set() methods.
    private class StorageWrapper<Value>: ObservableObject {

        let get: () -> Value
        let set: (Value) -> Void

        init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
            self.get = get
            self.set = set
        }

        public var wrappedValue: Value {
            get {
                self.get()
            }
            set {
                self.objectWillChange.send()
                self.set(newValue)
            }
        }

        public var projectedValue: Binding<Value> {
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
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage {

    /// Creates a property that can read and write to a boolean user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Bool {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write to an integer user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Int {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write to a double user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Double {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write to a string user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == String {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write to a url user default.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == URL {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write to a user default as data.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Data {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            (store.object(forKey: key) as? Value) ?? wrappedValue
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write to an integer user default,
    /// transforming that to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            if let rawValue = store.object(forKey: key) as? Value.RawValue {
                return Value(rawValue: rawValue) ?? wrappedValue
            }
            return wrappedValue
        }, set: {
            store.set($0.rawValue, forKey: key)
        })
    }

    /// Creates a property that can read and write to a string user default,
    /// transforming that to `RawRepresentable` data type.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            if let rawValue = store.object(forKey: key) as? Value.RawValue {
                return Value(rawValue: rawValue) ?? wrappedValue
            }
            return wrappedValue
        }, set: {
            store.set($0.rawValue, forKey: key)
        })
    }
}


@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage where Value : ExpressibleByNilLiteral {

    /// Creates a property that can read and write an Optional boolean user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Bool? {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional integer user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Int? {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional double user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Double? {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional string user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == String? {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional URL user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == URL? {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: {
            store.set($0, forKey: key)
        })
    }

    /// Creates a property that can read and write an Optional data user default.
    public init(_ key: String, store: UserDefaults? = nil) where Value == Data? {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            guard let value = (store.object(forKey: key) as? Value) else {
                return nil
            }
            return value
        }, set: {
            store.set($0, forKey: key)
        })
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AppStorage")
extension AppStorage {

    /// Creates a property that can save and restore an Optional string,
    /// transforming it to an Optional `RawRepresentable` data type.
    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == String {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            if let rawValue = store.object(forKey: key) as? R.RawValue {
                return R(rawValue: rawValue)
            }
            return nil
        }, set: {
            store.set($0?.rawValue, forKey: key)
        })
    }

    /// Creates a property that can save and restore an Optional integer,
    /// transforming it to an Optional `RawRepresentable` data type.
    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == Int {
        let store = store ?? .standard
        storage = StorageWrapper(get: {
            if let rawValue = store.object(forKey: key) as? R.RawValue {
                return R(rawValue: rawValue)
            }
            return nil
        }, set: {
            store.set($0?.rawValue, forKey: key)
        })
    }
}
