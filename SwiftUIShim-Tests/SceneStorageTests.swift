//
//  SceneStorageTests.swift
//  SwiftUIShim-Tests
//
//  Created by Philipp on 29.08.21.
//

import XCTest
@testable import SwiftUIShim

#if TARGET_IOS_MAJOR_13
// swiftlint:disable type_body_length
class SceneStorageTests: XCTestCase {

    // MARK: Bool
    func testSceneStorageBoolean() {
        // Type to be tested
        var value: SceneStorage<Bool>

        // Test configuration
        let key = "Bool"
        let defaultValue = true
        let newValue = false
        let externallySetValue = true

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Bool?
    func testSceneStorageOptionalBoolean() {
        // Type to be tested
        let value: SceneStorage<Bool?>

        // Test configuration
        let key = "OptionalBool"
        let defaultValue: Bool? = .none
        let newValue = false
        let externallySetValue = true

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Bool, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Int
    func testSceneStorageInteger() {
        // Type to be tested
        let value: SceneStorage<Int>

        // Test configuration
        let key = "Int"
        let defaultValue = 5
        let newValue = 10
        let externallySetValue = 20

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Int?
    func testSceneStorageOptionalInteger() {
        // Type to be tested
        let value: SceneStorage<Int?>

        // Test configuration
        let key = "OptionalInt"
        let defaultValue: Int? = .none
        let newValue = 10
        let externallySetValue = 20

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Int, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Double
    func testSceneStorageDouble() {
        // Type to be tested
        let value: SceneStorage<Double>

        // Test configuration
        let key = "Double"
        let defaultValue = 5.0
        let newValue = 10.0
        let externallySetValue = 20.0

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, newValue,
                       "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Double?
    func testSceneStorageOptionalDouble() {
        // Type to be tested
        let value: SceneStorage<Double?>

        // Test configuration
        let key = "OptionalDouble"
        let defaultValue: Double? = .none
        let newValue = 10.0
        let externallySetValue = 20.0

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Double, newValue,
                       "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: String
    func testSceneStorageString() {
        // Type to be tested
        let value: SceneStorage<String>

        // Test configuration
        let key = "String"
        let defaultValue = "default"
        let newValue = "new"
        let externallySetValue = "extern"

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, newValue,
                       "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: String?
    func testSceneStorageOptionalString() {
        // Type to be tested
        let value: SceneStorage<String?>

        // Test configuration
        let key = "OptionalString"
        let defaultValue: String? = .none
        let newValue = "new"
        let externallySetValue = "extern"

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? String, newValue,
                       "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: URL
    func testSceneStorageURL() {
        // Type to be tested
        let value: SceneStorage<URL>

        // Test configuration
        let key = "URL"
        let defaultValue = URL(string: "https://www.github.com")!
        let newValue = URL(string: "https://www.apple.com")!
        let externallySetValue = URL(string: "https://www.google.com")!

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? URL, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: URL?
    func testSceneStorageOptionalURL() {
        // Type to be tested
        let value: SceneStorage<URL?>

        // Test configuration
        let key = "OptionalURL"
        let defaultValue: URL? = .none
        let newValue = URL(string: "https://www.apple.com")
        let externallySetValue = URL(string: "https://www.google.com")

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? URL, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? URL, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue as Any, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Data
    func testSceneStorageData() {
        // Type to be tested
        let value: SceneStorage<Data>

        // Test configuration
        let key = "Data"
        let defaultValue = "https://www.github.com".data(using: .utf8)!
        let newValue = "https://www.apple.com".data(using: .utf8)!
        let externallySetValue = "https://www.google.com".data(using: .utf8)!

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Data, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: Data?
    func testSceneStorageOptionalData() {
        // Type to be tested
        let value: SceneStorage<Data?>

        // Test configuration
        let key = "OptionalData"
        let defaultValue: Data? = .none
        let newValue = "https://www.apple.com".data(using: .utf8)
        let externallySetValue = "https://www.google.com".data(using: .utf8)

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Data, nil, "no value SceneStorageValues should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? Data, newValue, "the new value should be persisted SceneStorageValues")

        store.set(externallySetValue as Any, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    private enum MyIntEnum: Int {
        case a, b, c
    }

    // MARK: RawRepresentable
    func testSceneStorageRawRepresentable() {
        // Type to be tested
        let value: SceneStorage<MyIntEnum>

        // Test configuration
        let key = "RawRepresentable"
        let defaultValue = MyIntEnum.a
        let newValue = MyIntEnum.b
        let externallySetValue = MyIntEnum.c

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? MyIntEnum, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(wrappedValue: defaultValue, key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the default value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? MyIntEnum, nil, "no value session store should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? MyIntEnum.RawValue, newValue.rawValue, "the new value should be persisted session store")

        store.set(externallySetValue.rawValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }

    // MARK: RawRepresentable?
    func testSceneStorageOptionalRawRepresentable() {
        // Type to be tested
        let value: SceneStorage<MyIntEnum?>

        // Test configuration
        let key = "OptionalRawRepresentable"
        let defaultValue: MyIntEnum? = .none
        let newValue = MyIntEnum.b
        let externallySetValue = MyIntEnum.c

        // Prepare setup
        let store = SceneStorageValuesKey.defaultValue
        store.removeObject(forKey: key)
        XCTAssertEqual(store.value(forKey: key) as? MyIntEnum, nil, "No value should be set after removal")

        // Test
        value = SceneStorage(key)
        XCTAssertEqual(value.wrappedValue, defaultValue, "if not set, the nil should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? MyIntEnum, nil, "no value session store should have been set")

        value.wrappedValue = newValue
        XCTAssertEqual(value.wrappedValue, newValue, "if set, the new value should be returned.")
        XCTAssertEqual(store.value(forKey: key) as? MyIntEnum.RawValue, newValue.rawValue, "the new value should be persisted session store")

        store.set(externallySetValue.rawValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")

        store.set(externallySetValue.rawValue, forKey: key)
        XCTAssertEqual(value.wrappedValue, externallySetValue,
                       "if modified externally, the new value should be returned")
    }
}
#endif

