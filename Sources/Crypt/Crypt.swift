//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

enum Algorithm: String {
    case unspecified = "UNSPECIFIED"
    case noCryptAlgo = "NO_CRYPT"
    case tsed25519V1 = "TSED25519_V1"
}

extension Algorithm {
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
    
    func newShare(content: [UInt8]) throws -> Share {
        var share: Share
        
        switch self {
        case .noCryptAlgo:
            let newCryptShare = NewNoCryptShare(content: content)
            share = newCryptShare
        case .tsed25519V1:
            share = NewNoCryptShare(content: content)
        default:
            throw CustomError.unsupportedAlgorithm
        }
        
        return share
    }
}

enum CustomError: Error {
    case unsupportedAlgorithm
}
