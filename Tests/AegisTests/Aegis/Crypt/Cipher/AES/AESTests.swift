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
        let secret = Data("MESSAGE_1".bytes)
        
        
        let encrypted = try AESencryptGCM(plainText: secret, key: key)
        
        let decrypted = try AESdecryptGCM(cipherText: encrypted, key: key)
        XCTAssertEqual(decrypted, secret)
    }
    
    func testAES1_1() throws {
        let key = Data("01234567890123456789012345678901".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        let decrypted = try AESdecryptGCM(cipherText: Data("cG/ezZh4VfsYDHPrMKMMDJdbYHGb0XAqVyJdo3QSS22mws7CIA==".bytes), key: key)
        XCTAssertEqual(decrypted, secret)
    }
    
    func testAES1_2() throws {
        let key = Data("01234567890123456789012345678901".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        let decrypted = try AESdecryptGCM(cipherText: Data("FCZwCSdf27zY/mLoc74+VFDvb7s/fln73VaV9WKNyLUPwdd0Dg==".bytes), key: key)
        XCTAssertEqual(decrypted, secret)
    }
    
    func testAES1_3() throws {
        let key = Data("01234567890123456789012345678901".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        let decrypted = try AESdecryptGCM(cipherText: Data("1Ugg5/Z58la6IOzhEXLgP77AwQ7iAvwbJm7H6URDyWyhuKFyQw==".bytes), key: key)
        XCTAssertEqual(decrypted, secret)
    }
      
    func testAES2() throws {
        let key = Data("012345678901234567890123456789ab".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        
        let encrypted = try AESencryptGCM(plainText: secret, key: key)
        
        let decrypted = try AESdecryptGCM(cipherText: encrypted, key: key)
        XCTAssertEqual(decrypted, secret)
    }
    
    func testAES2_1() throws {
        let key = Data("012345678901234567890123456789ab".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        let decrypted = try AESdecryptGCM(cipherText: Data("GX8i6t3yKtAIDow+V6QwLhHh2iR9war0EJxZIAWcMclaTfAf5A==".bytes), key: key)
        XCTAssertEqual(decrypted, secret)
    }
    
    func testAES2_2() throws {
        let key = Data("012345678901234567890123456789ab".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        let decrypted = try AESdecryptGCM(cipherText: Data("uF4MuvoNJun6Oemw7aP96JNUNhUo2pfoKdFHaQkFy92sVFDinA==".bytes), key: key)
        XCTAssertEqual(decrypted, secret)
    }
    
    func testAES2_3() throws {
        let key = Data("012345678901234567890123456789ab".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        let decrypted = try AESdecryptGCM(cipherText: Data("5pEp+ZztChtQ4rqYTjGBLnLPQbRcW/03fI8mb3DjxV7PBWf9Fg==".bytes), key: key)
        XCTAssertEqual(decrypted, secret)
    }
}
