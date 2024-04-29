//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

class VersionV1: Encodable {
    var crpytAlgorithm: String
    var sharePacket: Data
    var share: Share
    
    init(crpytAlgorithm: String, sharePacket: Data, share: Share) {
        self.crpytAlgorithm = crpytAlgorithm
        self.sharePacket = sharePacket
        self.share = share
    }
}

extension VersionV1 {
    func getVersion() -> Version { .V1 }
    
    func pack(v: Any) throws -> Data {
        guard let share = v as? Share else { throw PackError.protocolArgumentMismatch}
        self.crpytAlgorithm = share.getAlgorithm()
        self.sharePacket = share.serialize()
        self.share = share
        let v1 = VersionV1(
            crpytAlgorithm: self.crpytAlgorithm,
            sharePacket: self.sharePacket,
            share: self.share
        )
        let encoder = JSONEncoder()
        let data = try encoder.encode(v1)
        
        return data
    }
    
    func unpack(packet: Data) throws -> Share {
            try JSONDecoder().decode(VersionV1.self, from: packet)
            
            self.share = try crypt.algorithm(self.cryptAlgorithm).newShare(from: self.sharePacket)
            
            return self.share
        }
    
}
