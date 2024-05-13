//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

public let numMinimumShares = 3

public typealias Secret = Data

public extension Array where Element == UInt8 {
    func isEqual(to other: [UInt8]) -> Bool {
        return self == other
    }
}

public protocol ThresholdAlgorithm {
    func getName() -> Algorithm
    func dealShares(secret: Secret, threshold: UInt8, total: UInt8) -> [Share]
    func combineShares(shares: [Share]) -> Secret
}

public protocol Share {
    func getAlgorithm() -> Algorithm
    func serialize() -> Data
}


