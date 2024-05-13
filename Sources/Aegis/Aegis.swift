// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public typealias payload = Data

public class Aegis {
    var payloads: [payload]
    
    init() {
        self.payloads = []
    }
}

extension Aegis {
    public static func dealShares(pVersion: ProtocolVersion,
                    algorithm: Algorithm,
                    threshold: UInt8,
                    total: UInt8,
                    secret: Secret) throws -> Aegis {
        let aegis = Aegis()
        
        if threshold < numMinimumShares {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "too low threshold"])
        }
        
        // Deal
        let algo = try? algorithm.new()
        
        let shares = algo?.dealShares(secret: secret, threshold: threshold, total: total)
        
        // Verify
        let combined = algo?.combineShares(shares: shares ?? [Share]())
        
        if secret != combined {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "shares verification failed"])
        }
        
        // Pack
        shares?.forEach { share in
            let packed = try? pack(version: pVersion, v: share)
            aegis.payloads.append(packed ?? Data())
        }
        
        return aegis
    }
    
    public static func combineShares(payloads: [payload]) throws -> Secret {
        // Pre-verification
        if (payloads.isEmpty || payloads.count < numMinimumShares) {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "not enough shares"])
        }
        
        // Unpack
        var algorithm = Algorithm.unspecified
        
        var shares = [Share]()
        
        for payload in payloads {
            guard let share = try? unpack(packet: payload) as? Share else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Protocol argument mismatch"])
            }
            
            shares.append(share)
            
            if algorithm == Algorithm.unspecified {
                algorithm = share.getAlgorithm()
            } else if algorithm != share.getAlgorithm() {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "algorithm mismatch"])
            }
        }
        
        // Combine
        let algo = try algorithm.new()
        let combined = algo.combineShares(shares: shares)
        
        return combined
    }
}

public func Encrypt(cVersion: CipherVersion, secret: Secret, password: Data) throws -> Secret {
    let encrypted = try CipherEncrypt(version: cVersion, plainText: secret, password: password)
    
    // Verify
    let decrypted = try CipherDecrypt(cipherText: encrypted, password: password)
    guard decrypted == secret else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "encryption verification failed"])
    }
    
    return encrypted
}

public func Decrypt(secret: Secret, password: Data) throws -> Secret {
    // Decrypt
    let decrypted = try CipherDecrypt(cipherText: secret, password: password)
    
    return decrypted
}
