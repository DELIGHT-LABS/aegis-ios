//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

enum PackError: Error {
    case protocolArgumentMismatch
    case serializationError
}

let version0 = 0

class VersionV0: Protocol {}

extension VersionV0 {
    func getVersion() -> Version {
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


