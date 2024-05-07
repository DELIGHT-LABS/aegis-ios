//
//  File.swift
//  
//
//  Created by yun on 5/7/24.
//

import Foundation
import CryptoKit

let aesKeyLen = 32
let aesIvKeyLen = 16

class CipherV1 {}

extension CipherV1 {
    func encrypt(plainText: Data, password: Data) throws -> Data {
        // Prepare key
        let hashedKey = try Blake2b(size: aesKeyLen, message: password)
        
        // Prepare IvKey
        let ivKey = try Blake2b(size: aesIvKeyLen, message: password)
        
        // Encrypt
        return try AESencrypt(plainText: plainText, key: hashedKey, ivKey: ivKey)
    }
    
    func decrypt(cipherText: Data, password: Data) throws -> Data {
        // Prepare key
        let hashedKey = try Blake2b(size: aesKeyLen, message: password)
        
        // Prepare IvKey
        let ivKey = try Blake2b(size: aesIvKeyLen, message: password)
        
        // Encrypt
        return try AESdecrypt(cipherText: cipherText, key: hashedKey, ivKey: ivKey)
    }
}
