import XCTest
@testable import Aegis

final class CipherTests: XCTestCase {
    func testCipherV1_1() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        
        let encrypted = try CipherV1().encrypt(plainText: secret, password: password)
        let encoded = encrypted.base64EncodedString()
        XCTAssertEqual(encoded, "SXJTdWlYWjRMOE5DSElEWnpMbGY0RFFxdzNMUGFSQzV0c3pXWTc1RkFPQT0=")
        
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        
        let encrypted = try CipherV1().encrypt(plainText: secret, password: password)
        let encoded = encrypted.base64EncodedString()
        XCTAssertEqual(encoded, "b1RNNHJ4T2hEQmw2VkR6WWdsUitYZVArdWJram9yRE01ekhqRFdiTXZnMD0=")
        
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipher_1() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        
        let encrypted = try CipherEncrypt(version: CipherVersion.V1, plainText: secret, password: password)
        let encoded = encrypted.base64EncodedString()
        XCTAssertEqual(encoded, "VjEAAAAAAAAAAAAAAAAAAElyU3VpWFo0TDhOQ0hJRFp6TGxmNERRcXczTFBhUkM1dHN6V1k3NUZBT0E9")
        
        let decrypted = try CipherDecrypt(cipherText: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipher_2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        
        let encrypted = try CipherEncrypt(version: CipherVersion.V1, plainText: secret, password: password)
        let encoded = encrypted.base64EncodedString()
        XCTAssertEqual(encoded, "VjEAAAAAAAAAAAAAAAAAAG9UTTRyeE9oREJsNlZEellnbFIrWGVQK3Via2pvckRNNXpIakRXYk12ZzA9")
        
        let decrypted = try CipherDecrypt(cipherText: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
    }
}
