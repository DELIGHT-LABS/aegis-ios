import Foundation
import XCTest
@testable import Aegis

final class CitadelTests: XCTestCase {
    func testCitadel() async throws {
        let secret = Data("MESSAGE_1".bytes)
        let password = Data("01234567890123456789012345678901".bytes)
        
        let encryptedSecret = try Encrypt(cVersion: CipherVersion.V1, secret: secret, password: password)
        
        let aegis = try Aegis.dealShares(
            pVersion: ProtocolVersion.V1,
            algorithm: Algorithm.noCryptAlgo,
            threshold: 3,
            total: 3,
            secret: encryptedSecret
        )
        
        
        let token = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1ODhiOTZmYy03ZGFkLTRmNmQtYjczNy1iZDE2YjNmMGZmNTgiLCJzc29fcHJvdmlkZXIiOiJHb29nbGUiLCJpYXQiOjE3MTY1ODc0NjZ9.BvBltHARZwW3gDKFEw5kO1gG_89ikLUJu4Xfx5zpRY2o9j405idWq4kygiC7Iqnga4Zs7VBJF7aBRg_d6gk3Bg"
        let urls = [
            URL(string: "http://34.124.155.209:8080")!,
            URL(string: "http://34.124.155.209:8081")!,
            URL(string: "http://34.124.155.209:8082")!
        ]
        let citadel = Citadel(token: token, urls: urls)
        
        let uuid = Data("588b96fc-7dad-4f6d-b737-bd16b3f0ff58".bytes)
        
        try await citadel.store(payloads: aegis.payloads, key: uuid)
        
        let res = await citadel.retrieve(key: uuid)
        XCTAssertEqual(3, res.count)
        
        let encryptedRes = try Aegis.combineShares(payloads: res)
        let decryptedRes = try Decrypt(secret: encryptedRes, password: password)
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
        
        
        let token = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1ODhiOTZmYy03ZGFkLTRmNmQtYjczNy1iZDE2YjNmMGZmNTgiLCJzc29fcHJvdmlkZXIiOiJHb29nbGUiLCJpYXQiOjE3MTY1ODc0NjZ9.BvBltHARZwW3gDKFEw5kO1gG_89ikLUJu4Xfx5zpRY2o9j405idWq4kygiC7Iqnga4Zs7VBJF7aBRg_d6gk3Bg"
        let urls = [
            URL(string: "http://34.124.155.209:8080")!,
            URL(string: "http://34.124.155.209:8081")!,
            URL(string: "http://34.124.155.209:8082")!
        ]
        let citadel = Citadel(token: token, urls: urls)
        
        let uuid = Data("588b96fc-7dad-4f6d-b737-bd16b3f0ff58".bytes)
        
        try await citadel.store(payloads: aegis.payloads, key: uuid)
        
        citadel.forts[0].url = URL(string: "http://34.124.155.209:808")!
        
        let res = await citadel.retrieve(key: uuid)
        XCTAssertEqual(2, res.count)
        
    }
}
