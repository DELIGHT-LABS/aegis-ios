//
//  File.swift
//
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

enum Version: String, Codable {
    case V0 = "V0"
    case V1 = "V1"
}


typealias Packet = Data

struct Payload: Codable {
    let protocolVersion: ProtocolVersion
    var packet: Packet?
    
    enum CodingKeys: String, CodingKey {
        case protocolVersion = "protocol_version"
        case packet
    }
}

enum UnpackError: Error {
    case protocolError
    case invalidPacket
    case invalidAlgorithm
    case shareCreationFailed
}

protocol Protocol {
    func getVersion() -> Version
    func pack(_ v: Any) throws -> Data
    func unpack(_ packet: Data) throws -> Any
}

enum ProtocolError: Error {
    case unsupportedProtocol
}

func getProtocol(version: ProtocolVersion) throws -> Protocol {
    var pc: Protocol
    
    switch version {
    case .v0:
        return VersionV0()
    case .v1:
        return VersionV1()
    default:
        break
    }
}
