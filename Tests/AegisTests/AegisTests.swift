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
        let salt = Data("SALT_1".bytes)
        
        let encrypted = try Encrypt(cVersion: CipherVersion.V1, secret: secret, password: password, salt: salt)
        
        let decrypted = try Decrypt(secret: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
    
    func testEncryptAndDecrypt2() throws {
        let password = Data("PASSWORD_2".bytes)
        let secret = Data("MESSAGE_2".bytes)
        let salt = Data("SALT_2".bytes)
        
        let encrypted = try Encrypt(cVersion: CipherVersion.V1, secret: secret, password: password, salt: salt)
        
        let decrypted = try Decrypt(secret: encrypted, password: password, salt: salt)
        XCTAssertEqual(secret, decrypted)
    }
}

