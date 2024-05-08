// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

typealias payload = Data

class Aegis {
    var payloads: [payload]
    
    init() {
        self.payloads = []
    }
}

extension Aegis {
    static func dealShares(pVersion: ProtocolVersion,
                    cVersion: CipherVersion,
                    algorithm: Algorithm,
                    threshold: UInt8,
                    total: UInt8,
                    secret: Secret,
                    password: Data) throws -> Aegis {
        let aegis = Aegis()
        
        if threshold < numMinimumShares {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "too low threshold"])
        }
        
        // Encrypt
        let encrypted = try? Encrypt(version: cVersion, plainText: secret, password: password)
        
        // Deal
        let algo = try? algorithm.new()
        
        guard let encrypted else { return Aegis() }
        
        let shares = algo?.dealShares(secret: encrypted, threshold: threshold, total: total)
        
        // Verify
        let combined = algo?.combineShares(shares: shares ?? [Share]())
        
        if encrypted != combined {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "shares verification failed"])
        }
        
        // Pack
        shares?.forEach { share in
            let packed = try? pack(version: pVersion, v: share)
            aegis.payloads.append(packed ?? Data())
        }
        
        return aegis
    }
    
    func combineShares(password: Data) throws -> Secret {
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
        
        // Decrypt
        return try Decrypt(cipherText: combined, password: password)
    }
}
