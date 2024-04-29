//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

let numMinimumShares = 3

typealias Secret = [UInt8]

extension Array where Element == UInt8 {
    func isEqual(to other: [UInt8]) -> Bool {
        return self == other
    }
}

protocol ThresholdAlgorithm {
    func getName() -> String
    func dealShares(secret: Secret, threshold: UInt8, total: UInt8) -> [Share]
    func combineShares(shares: [Share], threshold: UInt8, total: UInt8) -> Secret
}

protocol Share: Encodable {
    func getAlgorithm() -> String
    func serialize() -> [UInt8]
}

