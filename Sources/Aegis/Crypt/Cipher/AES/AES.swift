import Foundation
import CryptoSwift

let hmacLen = 16

public func AESencrypt(plainText: Secret, key: Data, ivKey: Data) throws -> Data {
    // Append ivKey as HMAC
    let hmacText = ivKey + plainText

    let aes = try AES(key: key.bytes, blockMode: CBC(iv: ivKey.bytes), padding: .pkcs7)
    let encryptedBytes = try aes.encrypt(hmacText.bytes)

    // Base64 encoding
    let base64Cipher = encryptedBytes.toBase64()

    return Data(base64Cipher.utf8)
}

public func AESdecrypt(cipherText: Data, key: Data, ivKey: Data) throws -> Data {
    let decoded = Data(base64Encoded: cipherText)!
    
    let aes = try AES(key: key.bytes, blockMode: CBC(iv: ivKey.bytes), padding: .pkcs5)
    let decryptBytes = try aes.decrypt(decoded.bytes)

    return Data(decryptBytes[hmacLen...(decryptBytes.count - 1)])
}
