//
//  AppStorageTests.swift
//  iOS13-AppTests
//
//  Created by Philipp on 29.08.21.
//

import XCTest
@testable import iOS13_App

class AppStorageTests: XCTestCase {

    // MARK: Bool
    func testAppStorageBoolean() {
        // Type to be tested
        let value: AppStorage<Bool>

        // Test configuration
        let key = "Bool"
        let defaultValue = true
        let newValue = false
        let externallySetValue = true

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Bool, nil, "No value should be set after removal")

        // Test
        value = AppStorage(wrappedValue: defaultValue, key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: Bool?
    func testAppStorageOptionalBoolean() {
        // Type to be tested
        let value: AppStorage<Bool?>

        // Test configuration
        let key = "OptionalBool"
        let defaultValue: Bool? = .none
        let newValue = false
        let externallySetValue = true

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Bool, nil, "No value should be set after removal")

        // Test
        value = AppStorage(key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }


    // MARK: Int
    func testAppStorageInteger() {
        // Type to be tested
        let value: AppStorage<Int>

        // Test configuration
        let key = "Int"
        let defaultValue = 5
        let newValue = 10
        let externallySetValue = 20

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "No value should be set after removal")

        // Test
        value = AppStorage(wrappedValue: defaultValue, key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: Int?
    func testAppStorageOptionalInteger() {
        // Type to be tested
        let value: AppStorage<Int?>

        // Test configuration
        let key = "OptionalInt"
        let defaultValue: Int? = .none
        let newValue = 10
        let externallySetValue = 20

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "No value should be set after removal")

        // Test
        value = AppStorage(key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }


    // MARK: Double
    func testAppStorageDouble() {
        // Type to be tested
        let value: AppStorage<Double>

        // Test configuration
        let key = "Double"
        let defaultValue = 5.0
        let newValue = 10.0
        let externallySetValue = 20.0

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "No value should be set after removal")

        // Test
        value = AppStorage(wrappedValue: defaultValue, key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: Double?
    func testAppStorageOptionalDouble() {
        // Type to be tested
        let value: AppStorage<Double?>

        // Test configuration
        let key = "OptionalDouble"
        let defaultValue: Double? = .none
        let newValue = 10.0
        let externallySetValue = 20.0

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "No value should be set after removal")

        // Test
        value = AppStorage(key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }


    // MARK: String
    func testAppStorageString() {
        // Type to be tested
        let value: AppStorage<String>

        // Test configuration
        let key = "String"
        let defaultValue = "default"
        let newValue = "new"
        let externallySetValue = "extern"

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "No value should be set after removal")

        // Test
        value = AppStorage(wrappedValue: defaultValue, key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: String?
    func testAppStorageOptionalString() {
        // Type to be tested
        let value: AppStorage<String?>

        // Test configuration
        let key = "OptionalString"
        let defaultValue: String? = .none
        let newValue = "new"
        let externallySetValue = "extern"

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        print(store.dictionaryRepresentation()[key])
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "No value should be set after removal")

        // Test
        value = AppStorage(key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }


    // MARK: URL
    func testAppStorageURL() {
        // Type to be tested
        let value: AppStorage<URL>

        // Test configuration
        let key = "URL"
        let defaultValue = URL(string: "https://www.github.com")!
        let newValue = URL(string: "https://www.apple.com")!
        let externallySetValue = URL(string: "https://www.google.com")!

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "No value should be set after removal")

        // Test
        value = AppStorage(wrappedValue: defaultValue, key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.url(forKey: key), newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: URL?
    func testAppStorageOptionalURL() {
        // Type to be tested
        let value: AppStorage<URL?>

        // Test configuration
        let key = "OptionalURL"
        let defaultValue: URL? = .none
        let newValue = URL(string: "https://www.apple.com")
        let externallySetValue = URL(string: "https://www.google.com")

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "No value should be set after removal")

        // Test
        value = AppStorage(key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.url(forKey: key), newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: Data
    func testAppStorageData() {
        // Type to be tested
        let value: AppStorage<Data>

        // Test configuration
        let key = "Data"
        let defaultValue = "https://www.github.com".data(using: .utf8)!
        let newValue = "https://www.apple.com".data(using: .utf8)!
        let externallySetValue = "https://www.google.com".data(using: .utf8)!

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "No value should be set after removal")

        // Test
        value = AppStorage(wrappedValue: defaultValue, key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.data(forKey: key), newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }

    // MARK: Data?
    func testAppStorageOptionalData() {
        // Type to be tested
        let value: AppStorage<Data?>

        // Test configuration
        let key = "OptionalData"
        let defaultValue: Data? = .none
        let newValue = "https://www.apple.com".data(using: .utf8)
        let externallySetValue = "https://www.google.com".data(using: .utf8)

        // Prepare setup
        let store = UserDefaults(suiteName: #function)!
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "No value should be set after removal")

        // Test
        value = AppStorage(key, store: store)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "no value in UserDefaults should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.data(forKey: key), newValue, "the new value should be persisted in UserDefaults")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue, "if modified externally, the new value should be returned")
    }
}
