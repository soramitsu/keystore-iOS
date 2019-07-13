/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraKeystore

class KeychainManagerTests: XCTestCase {
    let keyStoreSync = Keychain()
    let keyIdentifier = "KeychainManagerTests.identifier"

    override func setUp() {
        super.setUp()

        try? keyStoreSync.deleteKey(for: keyIdentifier)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSaveLoadAsync() {
        // given
        let secret = "secret"

        // when
        let saveExpectation = XCTestExpectation()
        KeychainManager.shared.saveSecret(secret, for: keyIdentifier, completionQueue: DispatchQueue.main) {
            result in
            XCTAssertTrue(result)
            saveExpectation.fulfill()
        }

        wait(for: [saveExpectation], timeout: 10)

        let loadExpectation = XCTestExpectation()
        KeychainManager.shared.loadSecret(for: keyIdentifier, completionQueue: DispatchQueue.main) {
            value in
            XCTAssertEqual(value?.toUTF8String(), secret)
            loadExpectation.fulfill()
        }

        wait(for: [loadExpectation], timeout: 10)

        // then
        let isSaved = KeychainManager.shared.checkSecret(for: keyIdentifier)
        XCTAssertTrue(isSaved)
    }

    func testUpdateLoadAsync() {
        // given
        let secret = "secret"

        // when
        let saveExpectation = XCTestExpectation()
        KeychainManager.shared.saveSecret(secret, for: keyIdentifier, completionQueue: DispatchQueue.main) {
            result in
            XCTAssertTrue(result)
            saveExpectation.fulfill()
        }

        wait(for: [saveExpectation], timeout: 10)

        let newSecret = "newSecret"
        let updateExpectation = XCTestExpectation()
        KeychainManager.shared.saveSecret(newSecret, for: keyIdentifier, completionQueue: DispatchQueue.main) {
            result in
            XCTAssertTrue(result)
            updateExpectation.fulfill()
        }

        wait(for: [updateExpectation], timeout: 10)

        let loadExpectation = XCTestExpectation()
        KeychainManager.shared.loadSecret(for: keyIdentifier, completionQueue: DispatchQueue.main) {
            value in
            XCTAssertEqual(value?.toUTF8String(), newSecret)
            loadExpectation.fulfill()
        }

        wait(for: [loadExpectation], timeout: 10)

        // then
        let isSaved = KeychainManager.shared.checkSecret(for: keyIdentifier)
        XCTAssertTrue(isSaved)
    }

    func testCheckAsync() {
        // given
        let secret = "secret"

        // when
        let saveExpectation = XCTestExpectation()
        KeychainManager.shared.saveSecret(secret, for: keyIdentifier, completionQueue: DispatchQueue.main) {
            result in
            XCTAssertTrue(result)
            saveExpectation.fulfill()
        }

        wait(for: [saveExpectation], timeout: 10)

        let checkExpectation = XCTestExpectation()
        KeychainManager.shared.checkSecret(for: keyIdentifier, completionQueue: DispatchQueue.main) {
            result in
            XCTAssertTrue(result)
            checkExpectation.fulfill()
        }

        wait(for: [checkExpectation], timeout: 10)
    }

    func testSaveRemoveAsync() {
        // given
        let secret = "secret"

        // when
        let saveExpectation = XCTestExpectation()
        KeychainManager.shared.saveSecret(secret, for: keyIdentifier, completionQueue: DispatchQueue.main) {
            result in
            XCTAssertTrue(result)
            saveExpectation.fulfill()
        }

        wait(for: [saveExpectation], timeout: 10)

        let removeExpectation = XCTestExpectation()
        KeychainManager.shared.removeSecret(for: keyIdentifier, completionQueue: .main) {
            result in

            XCTAssertTrue(result)
            removeExpectation.fulfill()
        }

        wait(for: [removeExpectation], timeout: 10)
    }

    func testRemoveWhenNotExistsAsync() {
        let removeExpectation = XCTestExpectation()
        KeychainManager.shared.removeSecret(for: keyIdentifier, completionQueue: .main) {
            result in

            XCTAssertFalse(result)
            removeExpectation.fulfill()
        }

        wait(for: [removeExpectation], timeout: 10)
    }
}
