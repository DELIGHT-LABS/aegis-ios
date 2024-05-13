//
//  File.swift
//
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

public enum ProtocolVersion: String, Codable {
    case Unspecified = "UNSPECIFIED"
    case V0 = "V0"
    case V1 = "V1"
}

typealias Packet = Data

struct Payload: Codable {
    var protocolVersion: ProtocolVersion
    var packet: Packet
    
    enum CodingKeys: String, CodingKey {
        case protocolVersion = "protocol_version"
        case packet
    }
    
    init() {
        protocolVersion = ProtocolVersion.Unspecified
        packet = Data()
    }
}

enum UnpackError: Error {
    case protocolError
    case invalidPacket
    case invalidAlgorithm
    case shareCreationFailed
}

protocol Protocol {
    func getVersion() -> ProtocolVersion
    func pack(_ v: Any) throws -> Data
    func unpack(_ packet: Data) throws -> Any
}

enum ProtocolError: Error {
    case unsupportedProtocol
}

func getProtocol(version: ProtocolVersion) throws -> Protocol {
    switch version {
    case .V0:
        return ProtocolV0()
    case .V1:
        return ProtocolV1()
    default:
        throw NSError(domain: "protocol", code: 0, userInfo: [NSLocalizedDescriptionKey: "unsupported protocol"])
    }
}

func pack(version: ProtocolVersion, v: Any) throws -> Data {
    var p = Payload()
    p.protocolVersion = version
    
    let pc = try getProtocol(version: p.protocolVersion)
    
    p.packet = try pc.pack(v)
    
    let data = try JSONEncoder().encode(p)
    
    return data
}

func unpack(packet: Data) throws -> Any {
    let p = try JSONDecoder().decode(Payload.self, from: packet)
    
    let pc = try getProtocol(version: p.protocolVersion)
    
    let v = try pc.unpack(p.packet)
    
    return v
}
