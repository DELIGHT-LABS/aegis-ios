//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

struct NoCryptShare: Share {
    
    var content: [UInt8]
    
    func getAlgorithm() -> String {
        return NoCrypt().getName()
    }
    
    func serialize() -> [UInt8] {
        return self.content
    }
    
}

struct NoCrypt: ThresholdAlgorithm {}

extension NoCrypt {
    func getName() -> String {
        return
    }
    
    func dealShares(secret: Secret, threshold: UInt8, total: UInt8) -> [Share] {
        return
    }
    
    func combineShares(shares: [Share], threshold: UInt8, total: UInt8) -> Secret {
        return
    }
}

func NewNoCryptShare(content: [UInt8]) -> NoCryptShare {
    var share = NoCryptShare(content: content)
    return share
}

