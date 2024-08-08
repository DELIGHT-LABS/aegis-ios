// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public typealias payload = Data

public class Aegis {
    public var payloads: [String]
    
    public init() {
        self.payloads = []
    }
}

public extension Aegis {
    static func dealShares(pVersion: ProtocolVersion,
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
        
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        
        // Pack
        shares?.forEach { share in
            let packed = try? pack(version: pVersion, v: share, timestamp: timestamp)
            aegis.payloads.append(packed ?? "")
        }
        
        return aegis
    }
    
    static func combineShares(payloads: [String]) throws -> Secret {
        // Pre-verification
        if (payloads.isEmpty || payloads.count < numMinimumShares) {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "not enough shares"])
        }
        
        // Unpack
        var timestampToShares: [Int64: [Share]] = [:]
        for payload in payloads {
            let (share, timestamp) = try unpack(packet: payload)
            guard let share = share as? Share else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Protocol argument mismatch"])
            }
            
            timestampToShares[timestamp, default: []].append(share)
        }
        
        // pick majority shares
        var majorityShares: [Share] = []
        timestampToShares.forEach { (timestamp, shares) in
            if shares.count > majorityShares.count {
                majorityShares = shares
            }
        }
        
        // validation
        var algorithm = Algorithm.unspecified
        try majorityShares.forEach { (share) in
            if algorithm == Algorithm.unspecified {
                algorithm = share.getAlgorithm()
            } else if algorithm != share.getAlgorithm() {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "algorithm mismatch"])
            }
        }
        
        // Combine
        let algo = try algorithm.new()
        let combined = algo.combineShares(shares: majorityShares)
        
        return combined
    }
}

@available(macOS 10.15, *)
public func Encrypt(cVersion: CipherVersion, secret: Secret, password: Data, salt: Data) throws -> String {
    let encrypted = try CipherEncrypt(version: cVersion, plainText: secret, password: password, salt: salt)
    
    // Verify
    let decrypted = try CipherDecrypt(packet: encrypted, password: password, salt: salt)
    guard decrypted == secret else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "encryption verification failed"])
    }
    
    return encrypted
}

@available(macOS 10.15, *)
public func Decrypt(secret: String, password: Data, salt: Data) throws -> Secret {
    // Decrypt
    let decrypted = try CipherDecrypt(packet: secret, password: password, salt: salt)
    
    return decrypted
}
