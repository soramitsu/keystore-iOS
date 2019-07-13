/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraKeystore

class SettingsManagerTests: XCTestCase {
    var insertionKey = "TestDataKey"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        SettingsManager.shared.removeValue(for: insertionKey)

        super.tearDown()
    }

    func testDefaultValues() {
        let settings = SettingsManager.shared

        XCTAssertNil(settings.bool(for: insertionKey))
        XCTAssertNil(settings.integer(for: insertionKey))
        XCTAssertNil(settings.double(for: insertionKey))
        XCTAssertNil(settings.data(for: insertionKey))
        XCTAssertNil(settings.string(for: insertionKey))
    }

    func testInsertString() {
        // given
        let testString = "Test data string"

        // process
        SettingsManager.shared.set(value: testString, for: insertionKey)

        // expected
        let savedString = SettingsManager.shared.string(for: insertionKey)
        XCTAssertEqual(testString, savedString!)
    }

    func testInsertBool() {
        // given
        let testBool = true

        // process
        SettingsManager.shared.set(value: testBool, for: insertionKey)

        // expected
        let savedBool = SettingsManager.shared.bool(for: insertionKey)
        XCTAssertEqual(testBool, savedBool!)
    }

    func testInsertInt() {
        // given
        let testInt = 10

        // process
        SettingsManager.shared.set(value: testInt, for: insertionKey)

        // expected
        let savedInt = SettingsManager.shared.integer(for: insertionKey)
        XCTAssertEqual(testInt, savedInt!)
    }

    func testInsertDouble() {
        // given
        let testDouble: Double = 10.0

        // process
        SettingsManager.shared.set(value: testDouble, for: insertionKey)

        // expected
        let savedDouble = SettingsManager.shared.double(for: insertionKey)
        XCTAssertEqual(testDouble, savedDouble!)
    }

    func testInsertData() {
        // given
        let testData = "Test data".data(using: String.Encoding.utf8)!

        // process
        SettingsManager.shared.set(value: testData, for: insertionKey)

        // expected
        let savedData = SettingsManager.shared.data(for: insertionKey)
        XCTAssertEqual(testData, savedData!)
    }

    func testInsertRemoveData() {
        // given
        let testData = "Test data".data(using: String.Encoding.utf8)!

        // process
        SettingsManager.shared.set(value: testData, for: insertionKey)

        let savedData = SettingsManager.shared.data(for: insertionKey)
        XCTAssertEqual(testData, savedData!)

        SettingsManager.shared.removeValue(for: insertionKey)

        // expected
        XCTAssertNil(SettingsManager.shared.data(for: insertionKey))
    }

    func testInsertEncodable() {
        // given
        let dan = DummyPerson(name: "Dan", age: 40, parents: [], relations: [])
        let clara = DummyPerson(name: "Clara", age: 20, parents: [], relations: [])
        let steve = DummyPerson(name: "Steve", age: 20, parents: [dan], relations: [clara])

        // when
        SettingsManager.shared.set(value: steve, for: insertionKey)

        // then
        let fetchedPerson = SettingsManager.shared.value(of: DummyPerson.self, for: insertionKey)

        XCTAssertEqual(steve, fetchedPerson)
    }
}
