import XCTest
@testable import Aegis

final class AegisTests: XCTestCase {
    func testAegis() throws {
        let secret = Data("MESSAGE_1".bytes)
        
        let aegis = try Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 3,
            secret: secret
        )
        
        let combined = try Aegis.combineShares(payloads: aegis.payloads)
        XCTAssertEqual(secret, combined)
    }
    
    func testEncryptAndDecrypt1() throws {
        let password = Data("PASSWORD_1".bytes)
        let secret = Data("MESSAGE_1".bytes)
        
        
        let encrypted = try Encrypt(cVersion: CipherVersion.V1, secret: secret, password: password)
        
        let decrypted = try Decrypt(secret: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
        
        let decodedSecret = Data(base64Encoded: "eyJ2ZXJzaW9uIjoiVjEiLCJjaXBoZXJUZXh0IjoiU1hKVGRXbFlXalJNT0U1RFNFbEVXbnBNYkdZMFJGRnhkek5NVUdGU1F6VjBjM3BYV1RjMVJrRlBRVDA9In0=")!
        let result = try Decrypt(secret: decodedSecret, password: password)
        XCTAssertEqual(decrypted, result)
    }
    
    func testEncryptAndDecrypt2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        
        
        let encrypted = try Encrypt(cVersion: CipherVersion.V1, secret: secret, password: password)
        
        let decrypted = try Decrypt(secret: encrypted, password: password)
        XCTAssertEqual(secret, decrypted)
        
        let decodedSecret = Data(base64Encoded: "eyJ2ZXJzaW9uIjoiVjEiLCJjaXBoZXJUZXh0IjoiYjFSTk5ISjRUMmhFUW13MlZrUjZXV2RzVWl0WVpWQXJkV0pyYW05eVJFMDFla2hxUkZkaVRYWm5NRDA9In0=")!
        let result = try Decrypt(secret: decodedSecret, password: password)
        XCTAssertEqual(decrypted, result)
    }
}

