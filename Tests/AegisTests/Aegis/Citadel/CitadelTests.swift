import Foundation
import XCTest
@testable import Aegis

struct TestAegisSecret: Codable {
    var wallet: [TestWallet]
}

struct TestWallet: Codable {
    var address: String
    var name: String
    var publicKey: String
    var encrypted: String
}

final class CitadelTests: XCTestCase {
    func testCitadel() async throws {
        let secret = Data("MESSAGE_1".bytes)
        let password = Data("01234567890123456789012345678901".bytes)
        let salt = Data("SALT_1".bytes)
        
        let encryptedSecret = try Encrypt(cVersion: CipherVersion.V1, secret: secret, password: password, salt: salt)
        
        let wallet = TestWallet(address: "xpla1xxxx", name: "name1", publicKey: "publicKey1", encrypted: encryptedSecret)
        let aegisSecretData = TestAegisSecret(wallet: [wallet])
        let encodedAegisSecretData = try JSONEncoder().encode(aegisSecretData)
        
        let aegis = try Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 3,
            secret: encodedAegisSecretData
        )
        
        
        let token = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ4cGxhLWdhbWVzIiwic3ViIjoidGVzdEBkZWxpZ2h0bGFicy5pbyIsImV4cCI6MTc4NzMxMzM0OCwianRpIjoiYWFhYWFhYWEtYmJiYi1jY2NjLWRkZGQtZWVlZWVlZWVlZWVlIiwic3NvX3Byb3ZpZGVyIjoiR29vZ2xlIn0.CXMj447bNXTQwKgkNrwYzucPYH5uxYGQmuDbfb1F2eIZMvhenXa3zYn0PlI4N16BbuG9Riv9Q_LoN4-bUuPcBg"
        let urls = [
            URL(string: "https://citadel-fort1.develop.delightlabs.dev")!,
            URL(string: "https://citadel-fort2.develop.delightlabs.dev")!,
            URL(string: "https://citadel-fort3.develop.delightlabs.dev")!,
        ]
        let citadel = Citadel(token: token, urls: urls)
        
        let uuid = Data("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".bytes)
        
        try await citadel.store(payloads: aegis.payloads, key: uuid)
        
        let res = try await citadel.retrieve(key: uuid)
        XCTAssertEqual(3, res.count)
        
        let encryptedRes = try Aegis.combineShares(payloads: res)
        
        let resAegisSecret = try JSONDecoder().decode(TestAegisSecret.self, from: encryptedRes)
        
        let decryptedRes = try Decrypt(secret: resAegisSecret.wallet[0].encrypted, password: password, salt: salt)
        XCTAssertEqual(decryptedRes, secret)
        
    }
    
    func testCitadelRetrieveError() async throws {
        let secret = Data("MESSAGE_1".bytes)
        
        let aegis = try Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 3,
            secret: secret
        )
        
        
        let token = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ4cGxhLWdhbWVzIiwic3ViIjoidGVzdEBkZWxpZ2h0bGFicy5pbyIsImV4cCI6MTc4NzMxMzM0OCwianRpIjoiYWFhYWFhYWEtYmJiYi1jY2NjLWRkZGQtZWVlZWVlZWVlZWVlIiwic3NvX3Byb3ZpZGVyIjoiR29vZ2xlIn0.CXMj447bNXTQwKgkNrwYzucPYH5uxYGQmuDbfb1F2eIZMvhenXa3zYn0PlI4N16BbuG9Riv9Q_LoN4-bUuPcBg"
        let urls = [
            URL(string: "https://citadel-fort1.develop.delightlabs.dev")!,
            URL(string: "https://citadel-fort2.develop.delightlabs.dev")!,
            URL(string: "https://citadel-fort3.develop.delightlabs.dev")!,
        ]
        let citadel = Citadel(token: token, urls: urls)
        
        let uuid = Data("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".bytes)
        
        try await citadel.store(payloads: aegis.payloads, key: uuid)
        
        citadel.forts[0].url = URL(string: "http://1.2.3.4:5")!
        
        let res = try await citadel.retrieve(key: uuid)
        XCTAssertEqual(2, res.count)
        
    }
}
