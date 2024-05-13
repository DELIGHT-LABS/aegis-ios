//
//  File.swift
//  
//
//  Created by yun on 5/7/24.
//

import Foundation


public enum CipherVersion: String {
    case Unspecified = "UNSPECIFIED"
    case V1 = "V1"
}

public let versionHeaderLen = 16

public func CipherEncrypt(version: CipherVersion, plainText: Secret, password: Data) throws -> Secret {
    var encrypted: Secret
    switch version {
    case .V1:
        let encrypter = CipherV1()
        encrypted = try encrypter.encrypt(plainText: plainText, password: password)
    default:
        throw NSError(domain: "cipher", code: 0,userInfo: [NSLocalizedDescriptionKey: "unsupported version"])
    }
    
    // Append cipher version
    var v = Secret(repeating: 0, count: versionHeaderLen)
    let versionData = version.rawValue.data(using: .utf8)!
    v.replaceSubrange(0..<versionData.count, with: versionData)
    encrypted = v + encrypted
    
    return encrypted
}


public func CipherDecrypt(cipherText: Secret, password: Data) throws -> Secret {

    // Detach cipher version
    let versionData = String(bytes: cipherText[0..<versionHeaderLen], encoding: .utf8)?.replacingOccurrences(of: "\0", with: "")
    guard let version = CipherVersion(rawValue: versionData!) else {
        throw NSError(domain: "cipher", code: 0,userInfo: [NSLocalizedDescriptionKey: "invalid version"])
    }
    
    let encrypted = cipherText[versionHeaderLen...]
    var decrypted: Secret
    switch version {
    case .V1:
        let decrypter = CipherV1()
        decrypted = try decrypter.decrypt(cipherText: encrypted, password: password)
    default:
        throw NSError(domain: "cipher", code: 0,userInfo: [NSLocalizedDescriptionKey: "unsupported version"])
    }
    
    return decrypted
}
