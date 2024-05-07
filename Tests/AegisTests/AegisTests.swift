import XCTest
@testable import Aegis

final class AegisTests: XCTestCase {
    func testAegis() throws {
        let secret = Data("MESSAGE_1".bytes)
        let key = Data("01234567890123456789012345678901".bytes)
        
        let aegis = try Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            cVersion: CipherVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 3,
            secret: secret,
            password: key
        )
        
        let aegis2 = Aegis(threshold: 3, total: 3)
        aegis2.payloads = aegis.payloads
        let combined = try aegis2.combineShares(password: key)
        XCTAssertEqual(secret, combined)
    }
}

