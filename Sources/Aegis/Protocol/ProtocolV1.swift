//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

public class ProtocolV1: Codable, Protocol {
    public var cryptAlgorithm: String
    public var sharePacket: Data
    public var share: Share?
    
    public enum CodingKeys : String, CodingKey {
        case cryptAlgorithm = "crypt_algorithm"
        case sharePacket = "share_packet"
    }
    
    public init() {
        cryptAlgorithm = ""
        sharePacket = Data()
        
    }
    
    public init(cryptAlgorithm: String, sharePacket: Data, share: Share) {
        self.cryptAlgorithm = cryptAlgorithm
        self.sharePacket = sharePacket
        self.share = share
    }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cryptAlgorithm = try values.decode(String.self, forKey: .cryptAlgorithm)
        sharePacket = try values.decode(Data.self, forKey: .sharePacket)
    }
}

public extension ProtocolV1 {
    func getVersion() -> ProtocolVersion { .V1 }
    
    func pack(_ v: Any) throws -> Packet {
        guard let share = v as? Share else { throw PackError.protocolArgumentMismatch}
        self.cryptAlgorithm = share.getAlgorithm().rawValue
        self.sharePacket = share.serialize()
        
        guard let data = try? JSONEncoder().encode(self) else {
            throw PackError.protocolArgumentMismatch
        }
        
        return data
    }
    
    func unpack(_ packet: Packet) throws -> Any {
        let jsonData = packet as Data
        let v1 = try? JSONDecoder().decode(ProtocolV1.self, from: jsonData)
        let cryptAlgorithm = v1?.cryptAlgorithm
        let sharePacket = v1?.sharePacket
        
        guard let algorithm = Algorithm(rawValue: cryptAlgorithm ?? "") else {
            throw UnpackError.invalidAlgorithm
        }
        
        share = try algorithm.newShare(content: sharePacket ?? Data())
        
        return share
    }
    
}
