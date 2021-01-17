//
//  KeychainSampleTests.swift
//  KeychainSampleTests
//
//  Created by snowman on 2021/01/17.
//

import XCTest
@testable import KeychainSample
import CryptoKit

class KeychainSampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        guard let data = "testtest".data(using: .utf8) else {
            return
        }
        let key = "encryptedkey"
        let value = SHA256.hash(data: data).hexStr
        KeychainAccess.saveKeyChain(key: key, vaule: value)
        let result = KeychainAccess.getKeyChain(key: key)
        XCTAssertTrue(value == result)
    }


}
