/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraKeystore

class KeystoreTests: XCTestCase {
    let keyIdentifier = "com.sora.soratestkeyidentifier"
    let additionalKeyIdentifier = "com.sora.soratestadditionalkeyidentifier"

    let keystore = Keychain()

    override func setUp() {
        super.setUp()

        try? keystore.deleteKey(for: keyIdentifier)
        try? keystore.deleteKey(for: additionalKeyIdentifier)
    }

    override func tearDown() {
        try? keystore.deleteKey(for: keyIdentifier)
        try? keystore.deleteKey(for: additionalKeyIdentifier)

        super.tearDown()
    }

    func testKeyAddAndQueryExisting() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // then
        try! keystore.addKey(key, with: keyIdentifier)
        let resultKey = try! keystore.fetchKey(for: keyIdentifier)

        // expected
        XCTAssertTrue(key == resultKey)
    }

    func testKeyAddAndRemove() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // then
        try! keystore.addKey(key, with: keyIdentifier)
        try! keystore.deleteKey(for: keyIdentifier)

        // expected
        XCTAssertThrowsError(try keystore.fetchKey(for: keyIdentifier)) { error in
            XCTAssertEqual(error as! KeystoreError, KeystoreError.noKeyFound)
        }
    }

    func testKeyAddAndUpdateWithDifferentKey() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!
        let newKey = "ABqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // then
        try! keystore.addKey(key, with: keyIdentifier)
        try! keystore.updateKey(newKey, with: keyIdentifier)
        let resultKey = try! keystore.fetchKey(for: keyIdentifier)

        // expected
        XCTAssertTrue(newKey == resultKey)
    }

    func testKeyAddAndUpdateWithSameKey() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // then
        try! keystore.addKey(key, with: keyIdentifier)
        try! keystore.updateKey(key, with: keyIdentifier)
        let resultKey = try! keystore.fetchKey(for: keyIdentifier)

        // expected
        XCTAssertTrue(key == resultKey)
    }

    func testKeyNotFoundError() {
        // expected
        XCTAssertThrowsError(try keystore.fetchKey(for: keyIdentifier)) { error in
            XCTAssertEqual(error as! KeystoreError, KeystoreError.noKeyFound)
        }
    }

    func testCheckExistingKey() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // then
        try! keystore.addKey(key, with: keyIdentifier)

        // expected
        XCTAssertTrue(try! keystore.checkKey(for: keyIdentifier))
    }

    func testCheckNotExistingKey() {
        // expected
        XCTAssertFalse(try! keystore.checkKey(for: keyIdentifier))
    }

    func testDuplicateError() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // then
        try! keystore.addKey(key, with: keyIdentifier)

        // expected
        XCTAssertThrowsError(try keystore.addKey(key, with: keyIdentifier)) { error in
            XCTAssertEqual(error as! KeystoreError, KeystoreError.duplicatedItem)
        }
    }

    func testSuccessfullSave() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // when
        XCTAssertNoThrow(try keystore.saveKey(key, with: keyIdentifier))

        // then
        guard let data = try? keystore.fetchKey(for: keyIdentifier) else {
            XCTFail()
            return
        }

        XCTAssertEqual(key, data)
    }

    func testMultipleSaveForSameKey() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // when
        XCTAssertNoThrow(try keystore.saveKey(key, with: keyIdentifier))
        XCTAssertNoThrow(try keystore.saveKey(key, with: keyIdentifier))

        // then
        guard let data = try? keystore.fetchKey(for: keyIdentifier) else {
            XCTFail()
            return
        }

        XCTAssertEqual(key, data)
    }

    func testDeleteIfExistsWhenNoKey() {
        // then
        XCTAssertNoThrow(try keystore.deleteKeyIfExists(for: keyIdentifier))
    }

    func testDeleteIfExistsAfterSave() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // when
        XCTAssertNoThrow(try keystore.saveKey(key, with: keyIdentifier))

        XCTAssertEqual((try? keystore.checkKey(for: keyIdentifier)), true)

        // then
        XCTAssertNoThrow(try keystore.deleteKeyIfExists(for: keyIdentifier))
        XCTAssertEqual((try? keystore.checkKey(for: keyIdentifier)), false)
    }

    func testDeleteMultipleAfterSave() {
        // given
        let key = "HBqhfdFASRQ5eBBpu2y6c6KKi1az6bMx8v1JxX4iW1Q8".data(using: String.Encoding.utf8)!

        // when
        XCTAssertNoThrow(try keystore.saveKey(key, with: keyIdentifier))
        XCTAssertNoThrow(try keystore.saveKey(key, with: additionalKeyIdentifier))

        // then
        XCTAssertNoThrow(try keystore.deleteKeysIfExist(for: [keyIdentifier, additionalKeyIdentifier]))

        XCTAssertEqual((try? keystore.checkKey(for: keyIdentifier)), false)
        XCTAssertEqual((try? keystore.checkKey(for: additionalKeyIdentifier)), false)
    }
}
