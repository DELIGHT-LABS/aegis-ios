//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

struct NoCryptShare: Share {
    
    var content: Data
    
    func getAlgorithm() -> Algorithm {
        return NoCrypt().getName()
    }
    
    func serialize() -> Data {
        return self.content
    }
    
}

struct NoCrypt: ThresholdAlgorithm {}

extension NoCrypt {
    func getName() -> Algorithm {
        return Algorithm.noCryptAlgo
    }
    
    func dealShares(secret: Secret, threshold: UInt8, total: UInt8) -> [Share] {
        return
    }
    
    func combineShares(shares: [Share]) -> Secret {
        return
    }
}

func NewNoCryptShare(content: Data) -> NoCryptShare {
    var share = NoCryptShare(content: content)
    return share
}

