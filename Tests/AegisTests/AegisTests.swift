import XCTest
@testable import Aegis

final class AegisTests: XCTestCase {
    let oldSecret = Data("OLD_SECRET".bytes)
    let newSecret = Data("NEW_SECRET".bytes)
    var oldPayloads: [String] = []
    var newPayloads: [String] = []
    
    override func setUp() {
        super.setUp()
        
        let oldAegis = try! Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 5,
            secret: oldSecret
        )
        
        oldPayloads = oldAegis.payloads
        
        sleep(10)
        
        let newAegis = try! Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 5,
            secret: newSecret
        )
        
        newPayloads = newAegis.payloads
        
    }
    
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
    
    func testAegisPickMajorityNewIsMajority() throws {
        let payloads = [oldPayloads[0], newPayloads[1], newPayloads[2], newPayloads[3], newPayloads[4]]
        
        let secret = try Aegis.combineShares(payloads: payloads)
        XCTAssertEqual(newSecret, secret)
    }
    
    func testAegisPickMajorityNewIsMinority() throws {
        let payloads = [oldPayloads[0], oldPayloads[1], oldPayloads[2], newPayloads[3], newPayloads[4]]
        
        let secret = try Aegis.combineShares(payloads: payloads)
        XCTAssertEqual(oldSecret, secret)
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

