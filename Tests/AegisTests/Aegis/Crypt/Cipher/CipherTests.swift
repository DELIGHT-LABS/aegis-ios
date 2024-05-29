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
        
        let decrypted = try CipherDecrypt(packet: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
        
        let decodedPacket = Data(base64Encoded: "eyJ2ZXJzaW9uIjoiVjEiLCJjaXBoZXJUZXh0IjoiU1hKVGRXbFlXalJNT0U1RFNFbEVXbnBNYkdZMFJGRnhkek5NVUdGU1F6VjBjM3BYV1RjMVJrRlBRVDA9In0=")!
        let result = try CipherDecrypt(packet: decodedPacket, password: password)
        XCTAssertEqual(decrypted, result)
    }
    
    func testCipher_2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        
        let encrypted = try CipherEncrypt(version: CipherVersion.V1, plainText: secret, password: password)
        
        let decrypted = try CipherDecrypt(packet: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
        
        let decodedPacket = Data(base64Encoded: "eyJ2ZXJzaW9uIjoiVjEiLCJjaXBoZXJUZXh0IjoiYjFSTk5ISjRUMmhFUW13MlZrUjZXV2RzVWl0WVpWQXJkV0pyYW05eVJFMDFla2hxUkZkaVRYWm5NRDA9In0=")!
        let result = try CipherDecrypt(packet: decodedPacket, password: password)
        XCTAssertEqual(decrypted, result)
    }
}
