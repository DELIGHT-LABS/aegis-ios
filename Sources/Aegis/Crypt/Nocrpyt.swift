//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

struct NoCryptShare: Share, Codable {
    var total: UInt8
    var threshold: UInt8
    var content: Data
    
    init() {
        total = 0
        threshold = 0
        content = Data()
    }
    
    init(encodeData: Data) {
        let share = try? JSONDecoder().decode(NoCryptShare.self, from: encodeData)
        total = share?.total ?? 0;
        threshold = share?.threshold ?? 0
        content = share?.content ?? Data()
    }
    
    func getAlgorithm() -> Algorithm {
        return NoCrypt().getName()
    }
    
    func serialize() -> Data {
        let data = try? JSONEncoder().encode(self)
        return data!
    }
    
}

struct NoCrypt: ThresholdAlgorithm {}

extension NoCrypt {
    func getName() -> Algorithm {
        return Algorithm.noCryptAlgo
    }

    func dealShares(secret: Secret, threshold: UInt8, total: UInt8) -> [Share] {
        var ncShares = [NoCryptShare]()
        for _ in 0..<total {
            var ncShare = NoCryptShare()
            ncShare.content = secret
            ncShares.append(ncShare)
        }
        
        // Type conversion for array of protocol
        var shares = [Share]()
        for share in ncShares {
            shares.append(share as Share)
        }
        
        return shares
    }
    
    func combineShares(shares: [Share]) -> Secret {
        if shares.count < numMinimumShares {
            // TODO: error handling
            fatalError()
        }

        // Type conversion
        var ncShares = [NoCryptShare]()
        for share in shares {
            guard let ncShare = share as? NoCryptShare else {
                fatalError()
            }
            ncShares.append(ncShare)
        }

        if ncShares.isEmpty || shares.count < Int(ncShares[0].threshold) {
            // TODO: error handling
            return Data()
        }

        return ncShares[0].content
    }
}
