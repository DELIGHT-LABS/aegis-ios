//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

enum PackError: Error {
    case protocolArgumentMismatch
}

let version0 = 0

class VersionV0 {
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
}

extension VersionV0 {
    func getVersion() -> Version {
        return .V0
    }
    
    func pack(v: Any) throws -> Data {
        guard let data = v as? Data else {
            throw PackError.protocolArgumentMismatch
        }
        return data
    }
    
    func unpack(packet: Packet) throws -> Any {
        return [UInt8](packet)
    }
}

