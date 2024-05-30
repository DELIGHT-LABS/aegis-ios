//
//  File.swift
//  
//
//  Created by yun on 5/7/24.
//

import Foundation
import CryptoKit
import CryptoSwift

public let aesKeyLen = 32
public let aesIvKeyLen = 16

public class CipherV1 {}

@available(macOS 10.15, *)
public extension CipherV1 {
    func encrypt(plainText: Data, password: Data, salt: Data) throws -> Secret {
        // Prepare key
        let hashedKey = try Blake2b(size: aesKeyLen, message: password + salt)
        
        // Encrypt
        let encrypted = try AESencryptGCM(plainText: plainText, key: hashedKey)
        
        return encrypted
    }
    
    func decrypt(cipherText: Data, password: Data, salt: Data) throws -> Secret {
        // Prepare key
        let hashedKey = try Blake2b(size: aesKeyLen, message: password + salt)
        // Encrypt
        return try! AESdecryptGCM(cipherText: cipherText, key: hashedKey)
    }
}
