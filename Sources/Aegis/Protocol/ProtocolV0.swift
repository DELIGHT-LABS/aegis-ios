//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

public enum PackError: Error {
    case protocolArgumentMismatch
    case serializationError
}

public let version0 = 0

public class ProtocolV0: Protocol {}

public extension ProtocolV0 {
    func getVersion() -> ProtocolVersion {
        return .V0
    }
    
    func pack(_ v: Any) throws -> Packet {
        guard let data = v as? Data else {
            throw PackError.protocolArgumentMismatch
        }
        return data
    }
    
    func unpack(_ packet: Packet) throws -> Any {
        return [UInt8](packet)
    }
}


