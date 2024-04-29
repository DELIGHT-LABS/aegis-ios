//
//  File.swift
//
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

enum Version: String {
    case V0 = "V0"
    case V1 = "V1"
}

typealias packet = Data

protocol Protocol {
    func getVersion() -> Version
    func pack(v: Any) throws -> (packet: Any, error: Error)
    func unpack(packet: Any) throws -> (value: Any, error: Error)
}

struct Payload: Codable {
    var protocolVersion: Version
    var packet: Packet
    
    private enum CodingKeys: String, CodingKey {
        case protocolVersion = "protocol_version"
        case packet
    }
}
