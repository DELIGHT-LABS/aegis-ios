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

public struct Payload: Codable {
    public var protocolVersion: ProtocolVersion
    public var packet: Packet
    
    public enum CodingKeys: String, CodingKey {
        case protocolVersion = "protocol_version"
        case packet
    }
    
    public init() {
        protocolVersion = ProtocolVersion.Unspecified
        packet = Data()
    }
}

public enum UnpackError: Error {
    case protocolError
    case invalidPacket
    case invalidAlgorithm
    case shareCreationFailed
}

public protocol Protocol {
    func getVersion() -> ProtocolVersion
    func pack(_ v: Any) throws -> Packet
    func unpack(_ packet: Packet) throws -> Any
}

public enum ProtocolError: Error {
    case unsupportedProtocol
}

public func getProtocol(version: ProtocolVersion) throws -> Protocol {
    switch version {
    case .V0:
        return ProtocolV0()
    case .V1:
        return ProtocolV1()
    default:
        throw NSError(domain: "protocol", code: 0, userInfo: [NSLocalizedDescriptionKey: "unsupported protocol"])
    }
}

public func pack(version: ProtocolVersion, v: Any) throws -> String {
    var p = Payload()
    p.protocolVersion = version
    
    let pc = try getProtocol(version: p.protocolVersion)
    
    p.packet = try pc.pack(v)
    
    let data = try JSONEncoder().encode(p)
    
    return data.base64EncodedString()
}

public func unpack(packet: String) throws -> Any {
    let decoded = Data(base64Encoded: packet)!
    
    let p = try JSONDecoder().decode(Payload.self, from: decoded)
    
    let pc = try getProtocol(version: p.protocolVersion)
    
    let v = try pc.unpack(p.packet)
    
    return v
}
