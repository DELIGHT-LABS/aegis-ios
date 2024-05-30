//
//  File.swift
//  
//
//  Created by yun on 5/7/24.
//

import Foundation


public enum CipherVersion: String, Codable {
    case Unspecified = "UNSPECIFIED"
    case V1 = "V1"
}

struct CipherPacket: Codable {
    var version: CipherVersion
    var cipherText: Data
    
    init(version: CipherVersion, cipherText: Data) {
        self.version = version
        self.cipherText = cipherText
    }
}

@available(macOS 10.15, *)
public func CipherEncrypt(version: CipherVersion, plainText: Secret, password: Data, salt: Data) throws -> String {
    var packet: CipherPacket
    
    var encrypted: Secret
    switch version {
    case .V1:
        let encrypter = CipherV1()
        encrypted = try encrypter.encrypt(plainText: plainText, password: password, salt: salt)
        
        packet = CipherPacket(version: CipherVersion.V1, cipherText: encrypted)
    default:
        throw NSError(domain: "cipher", code: 0,userInfo: [NSLocalizedDescriptionKey: "unsupported version"])
    }
    
    let packed = try JSONEncoder().encode(packet)
    
    return packed.base64EncodedString()
}


@available(macOS 10.15, *)
public func CipherDecrypt(packet: String, password: Data, salt: Data) throws -> Secret {
    // Base64 decoding
    let decoded = Data(base64Encoded: packet)!
    
    let cipher = try JSONDecoder().decode(CipherPacket.self, from: decoded)
    
    var decrypted: Secret
    switch cipher.version {
    case .V1:
        let decrypter = CipherV1()
        decrypted = try decrypter.decrypt(cipherText: cipher.cipherText, password: password, salt: salt)
    default:
        throw NSError(domain: "cipher", code: 0,userInfo: [NSLocalizedDescriptionKey: "unsupported version"])
    }
    
    return decrypted
}
