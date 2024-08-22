//
//  File.swift
//  
//
//  Created by yun on 5/7/24.
//

import XCTest
@testable import Aegis

final class Blake2bTests: XCTestCase {
    func testBlake2b() throws {
        let msg = Data("MESSAGE_1".utf8)
        
        let hashed = try Blake2b(size: 16, message: msg)
        let encoded = hashed.base64EncodedString()
        XCTAssertEqual(encoded, "Hic2zt1El2Y8DP9nWU7J7Q==")
        
        
        let hashed2 = try Blake2b(size: 32, message: msg)
        let encoded2 = hashed2.base64EncodedString()
        XCTAssertEqual(encoded2, "U0l/Dirpdm8S7d9YhObO+UjaXaQhSf16px09BCVG+U0=")
        
        
        
        let msg2 = Data("MESSAGE_2".utf8)
        
        let hashed3 = try Blake2b(size: 16, message: msg2)
        let encoded3 = hashed3.base64EncodedString()
        XCTAssertEqual(encoded3, "uFTfD9lzYLh2+JU/bftzLw==")
        
        let hashed4 = try Blake2b(size: 32, message: msg2)
        let encoded4 = hashed4.base64EncodedString()
        XCTAssertEqual(encoded4, "SQnar3aTns+q+THbN5LrcTYHZfdJs/GCu1CejmwHbcE=")
    }
    
    func testChecksum() throws {
        let res1 = try Checksum(message: "TEST1")
        XCTAssertEqual(res1, "6e2323ffbd238097ea541302a5b15d40ea23f9cd69d3664a6b7b07f6d0dc87f04d4534b03764d67c2b69dcbe4743bc0ad91082d54a139d4095920865d7216eda")
        
        let res2 = try Checksum(message: "TEST2")
        XCTAssertEqual(res2, "e97c7ee5e87d89409a2072f0a7fdadd7abc8aa6eb13d5f94465ab418ebf35f92d92d8797275149d5efa4fe08da656a8fc737daab0f75a726cac39b462857e492")
        
        let res3 = try Checksum(message: "TEST3")
        XCTAssertEqual(res3, "57757b849a72bb4c0c0efd58ebb9729296c3eb4630bd5bf16ee9e15c1d37977d3a149a7f763261a341e4335ec57b9e1453958730b52ba0b108d68fa723e55223")
    }
}
