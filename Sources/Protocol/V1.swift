//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

class VersionV1: Codable {
    var cryptAlgorithm: String
    var sharePacket: Data
    var share: Share
    
    init(cryptAlgorithm: String, sharePacket: Data, share: Share) {
        self.cryptAlgorithm = cryptAlgorithm
        self.sharePacket = sharePacket
        self.share = share
    }
}

extension VersionV1 {
    func getVersion() -> Version { .V1 }
    
    func pack(_ v: Any) throws -> Packet {
        guard let share = v as? Share else { throw PackError.protocolArgumentMismatch}
        self.cryptAlgorithm = share.getAlgorithm().rawValue
        self.sharePacket = share.serialize()
        self.share = share
        
        guard let data = try? JSONEncoder().encode(self) else {
            throw PackError.protocolArgumentMismatch
        }
        
        return data
    }
    
    func unpack(_ packet: Packet) throws -> Any {
        let jsonData = packet as? Data
        let v1 = try? JSONDecoder().decode(VersionV1.self, from: jsonData ?? Data())
        let cryptAlgorithm = v1?.cryptAlgorithm
        let sharePacket = v1?.sharePacket
        
        guard let algorithm = Algorithm(rawValue: cryptAlgorithm ?? "") else {
            throw UnpackError.invalidAlgorithm
        }
        
        share = try algorithm.newShare(content: sharePacket ?? Data())
        
        return share
        
    }
    
}
