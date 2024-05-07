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
}
