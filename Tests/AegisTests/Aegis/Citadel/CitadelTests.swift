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
        
        
        let token = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ5b3VuZ0BkZWxpZ2h0bGFicy5pbyIsImV4cCI6MTc0Njc4NDczMCwianRpIjoiOGJmYTVkMjgtZjkxZi00YmQ3LTgxYTMtZGM4NjllYWVkNmYyIiwic3NvX3Byb3ZpZGVyIjoiR29vZ2xlIn0.ukJ0gYQsZRE8gktRtzxA6cfPH97zWzwLTmU8DODX9sOSwnLPJ0dFFssTbQm0WE-Cfl95COAAl6WwuQ6NSVEIDg"
        let urls = [
            URL(string: "http://34.124.155.209:8080")!,
            URL(string: "http://34.124.155.209:8081")!,
            URL(string: "http://34.124.155.209:8082")!
        ]
        let citadel = Citadel(token: token, urls: urls)
        
        let uuid = Data("8bfa5d28-f91f-4bd7-81a3-dc869eaed6f2".bytes)
        
        try await citadel.store(payloads: aegis.payloads, key: uuid)
        
        let res = await citadel.retrieve(key: uuid)
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
        
        
        let token = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ5b3VuZ0BkZWxpZ2h0bGFicy5pbyIsImV4cCI6MTc0Njc4NDczMCwianRpIjoiOGJmYTVkMjgtZjkxZi00YmQ3LTgxYTMtZGM4NjllYWVkNmYyIiwic3NvX3Byb3ZpZGVyIjoiR29vZ2xlIn0.ukJ0gYQsZRE8gktRtzxA6cfPH97zWzwLTmU8DODX9sOSwnLPJ0dFFssTbQm0WE-Cfl95COAAl6WwuQ6NSVEIDg"
        let urls = [
            URL(string: "http://34.124.155.209:8080")!,
            URL(string: "http://34.124.155.209:8081")!,
            URL(string: "http://34.124.155.209:8082")!
        ]
        let citadel = Citadel(token: token, urls: urls)
        
        let uuid = Data("8bfa5d28-f91f-4bd7-81a3-dc869eaed6f2".bytes)
        
        try await citadel.store(payloads: aegis.payloads, key: uuid)
        
        citadel.forts[0].url = URL(string: "http://34.124.155.209:808")!
        
        let res = await citadel.retrieve(key: uuid)
        XCTAssertEqual(2, res.count)
        
    }
}
