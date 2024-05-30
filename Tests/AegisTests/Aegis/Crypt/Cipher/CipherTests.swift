import XCTest
@testable import Aegis

final class CipherTests: XCTestCase {
    func testCipherV1_1() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        let salt = Data("SALT_1".bytes)
        
        
        let encrypted = try CipherV1().encrypt(plainText: secret, password: password, salt: salt)
        
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_1_1() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        let salt = Data("SALT_1".bytes)
        
        
        let encrypted = Data("6KcuRTR1lbNhcNBlXbvQmV1lbW3XoPIm7t4q+lpZslLy3mbszg==".bytes)
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_1_2() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        let salt = Data("SALT_1".bytes)
        
        
        let encrypted = Data("V6Kmmvcl3oxCj8vXckXwQDcovKo2kBC9Q+wB0qFPt3mU2wYriw==".bytes)
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_1_3() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        let salt = Data("SALT_1".bytes)
        
        
        let encrypted = Data("U0vFcOsKI+2zAET9K6Qj6pAwpoRwTXmsMFgDfGuZo5E+0Kecfg==".bytes)
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        let salt = Data("SALT_2".bytes)
        
        
        let encrypted = try CipherV1().encrypt(plainText: secret, password: password, salt: salt)
        
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_2_1() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        let salt = Data("SALT_2".bytes)
        
        let encrypted = Data("SRCQlBBY7/oHAliYuyKo+PGSHgG5hsIpKreh1m3XIToZ5uVzUg==".bytes)
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_2_2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        let salt = Data("SALT_2".bytes)
        
        let encrypted = Data("AN5gLlJnG1N8DkI8Nie8tybSkFCrAq0lK/2UB2RYKFG+LkIMgA==".bytes)
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipherV1_2_3() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        let salt = Data("SALT_2".bytes)
        
        let encrypted = Data("HIXTwrwkt8EevwXvCa2XoUaQ2PJJVwUOL0a9EW6hOzvrNGATmA==".bytes)
        let decrypted = try CipherV1().decrypt(cipherText: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipher_1() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        let salt = Data("SALT_1".bytes)
        
        
        let encrypted = try CipherEncrypt(version: CipherVersion.V1, plainText: secret, password: password, salt: salt)
        
        let decrypted = try CipherDecrypt(packet: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testCipher_2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        let salt = Data("SALT_2".bytes)
        
        
        let encrypted = try CipherEncrypt(version: CipherVersion.V1, plainText: secret, password: password, salt: salt)
        
        let decrypted = try CipherDecrypt(packet: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
}
