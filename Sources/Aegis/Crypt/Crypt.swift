//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

public enum Algorithm: String {
    case unspecified = "UNSPECIFIED"
    case noCryptAlgo = "NO_CRYPT"
    case tsed25519V1 = "TSED25519_V1"
}

public extension Algorithm {
    func new() throws -> ThresholdAlgorithm {
        switch self {
        case .noCryptAlgo:
            return NoCrypt()
        case .tsed25519V1:
            return Ed25519ThresholdV0()
        default:
            throw CustomError.unsupportedAlgorithm
        }
    }
    
    func newShare(content: Data) throws -> Share {
        var share: Share
        
        switch self {
        case .noCryptAlgo:
            share = NoCryptShare(encodeData: content)
        case .tsed25519V1:
            share = newEd25519ThresholdV0Share(content: content)!
        default:
            throw CustomError.unsupportedAlgorithm
        }
        
        return share
    }
}

public enum CustomError: Error {
    case unsupportedAlgorithm
}
