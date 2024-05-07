//
//  File.swift
//  
//
//  Created by yun on 5/7/24.
//

import XCTest
@testable import Aegis

final class AESTests: XCTestCase {
    func testAES1() throws {
        let key = Data("01234567890123456789012345678901".bytes)
        let ivKey = Data("0123456789012345".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        
        let encrypted = try AESencrypt(plainText: secret, key: key, ivKey: ivKey)
        let encoded = encrypted.base64EncodedString()
        XCTAssertEqual(encoded, "OTh1VC9tZ0JZWFI4QVpUbW8xdXI2bW1OR0ZGd3VwREREbjNENmp5WHRmZz0=")
        
        let decrypted = try AESdecrypt(cipherText: encrypted, key: key, ivKey: ivKey)
        XCTAssertEqual(decrypted, secret)
    }
      
    func testAES2() throws {
        let key = Data("012345678901234567890123456789ab".bytes)
        let ivKey = Data("0123456789abcdef".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        
        let encrypted = try AESencrypt(plainText: secret, key: key, ivKey: ivKey)
        let encoded = encrypted.base64EncodedString()
        XCTAssertEqual(encoded, "K1Fac2RkNUZXdkFXYTlFQUk3REx4ZzBIQURWRmYwZmd2RnlnY1ZCRm9YUT0=")
        
        let decrypted = try AESdecrypt(cipherText: encrypted, key: key, ivKey: ivKey)
        XCTAssertEqual(decrypted, secret)
    }
}
