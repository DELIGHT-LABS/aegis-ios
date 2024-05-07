// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

typealias payload = Data

enum ProtocolVersion: Codable {
    case v0
    case v1
    case unspecified
}

enum CipherVersion {
    case unspecified
    case v1
}

class Aegis {
    var payloads: [Data]?
    let threshold: UInt8?
    let total: UInt8?
    
    init(payloads: [Data]? = nil, threshold: UInt8?, total: UInt8?) {
        self.payloads = payloads
        self.threshold = threshold
        self.total = total
    }
}

extension Aegis {
    static let NUM_MINIMUM_SHARE = 1
    
    func dealShares(pVersion: ProtocolVersion,
                    cVersion: CipherVersion,
                    algorithm: Algorithm,
                    threshold: UInt8,
                    total: UInt8,
                    secret: Secret,
                    password: Data) throws -> Aegis {
        let aegis = Aegis(threshold: threshold, total: total)
        
        if threshold < Aegis.NUM_MINIMUM_SHARE {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "too low threshold"])
        }
        
        // Encrypt
        let encrypted = try? encrypt(cVersion: cVersion, secret: secret, password: password)
        
        // Deal
        let algo = try? algorithm.new()
        
        guard let encrypted else { return Aegis(threshold: 0, total: 0) }
        
        let shares = algo?.dealShares(secret: encrypted, threshold: threshold, total: total)
        
        // Verify
        let combined = algo?.combineShares(shares: shares ?? [Share]())
        
        if encrypted != combined {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "shares verification failed"])
        }
        
        // Pack
        shares?.forEach { share in
            let packed = try? pack(version: pVersion, v: share)
            aegis.payloads?.append(packed ?? Data())
        }
        
        return aegis
    }
    
    func combineShares(password: Data) throws -> Secret {
        // Pre-verification
        if ((payloads?.isEmpty) != nil) || (payloads?.count ?? 0 < Aegis.NUM_MINIMUM_SHARE) {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "not enough shares"])
        }
        
        // Unpack
        var algorithm = Algorithm.unspecified
        
        var shares = [Share]()
        guard let payloads else { return Secret() }
        
        for payload in payloads {
            guard let share = try? unpack(payload) as? Share else {
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
        return try decrypt(combined: combined, password: password)
    }
}

extension Aegis {
    func pack(version: ProtocolVersion, v: Any) throws -> Data {
        var p = Payload(protocolVersion: version, packet: nil)
        
        var pc = try getProtocol(version: p.protocolVersion)
        p.packet = try pc.pack(p.protocolVersion)
        
        guard let packet = p.packet else { return Data() }
        
        do {
            let jsonData = try JSONEncoder().encode(p)
            return jsonData
        } catch {
            throw error
        }
    }
    
    func unpack(_ data: Data) throws -> Any {
        let p = try JSONDecoder().decode(Payload.self, from: data)
        
        let pc = try getProtocol(version: p.protocolVersion)
        
        do {
            let v = try pc.unpack(p.packet ?? Data())
            return v
        } catch {
            throw error
        }
    }
    
    func encrypt(cVersion: CipherVersion, secret: Secret, password: Data) throws -> Data {
        // Encryption code goes here
        return Data()
    }
    
    func decrypt(combined: Data, password: Data) throws -> Secret {
        // Decryption code goes here
        return Secret()
    }
}
