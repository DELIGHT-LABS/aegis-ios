import Foundation
import CryptoKit

public let hmacLen = 16

@available(macOS 10.15, *)
public func AESencryptGCM(plainText: Secret, key: Data) throws -> Data {
    let sealed = try! AES.GCM.seal(plainText, using: SymmetricKey(data: key))
    let encrypted = sealed.combined!
    return encrypted.base64EncodedData()
}

@available(macOS 10.15, *)
public func AESdecryptGCM(cipherText: Data, key: Data) throws -> Data {
    let decoded = Data(base64Encoded: cipherText)!
    let sealedBox = try! AES.GCM.SealedBox(combined: decoded)
    let decrypted = try! AES.GCM.open(sealedBox, using: SymmetricKey(data: key))
    return decrypted
}
