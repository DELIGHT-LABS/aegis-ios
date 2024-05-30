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
public func CipherEncrypt(version: CipherVersion, plainText: Secret, password: Data, salt: Data) throws -> Secret {
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
    
    return try JSONEncoder().encode(packet)
}


@available(macOS 10.15, *)
public func CipherDecrypt(packet: Packet, password: Data, salt: Data) throws -> Secret {
    let cipher = try JSONDecoder().decode(CipherPacket.self, from: packet)
    
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
