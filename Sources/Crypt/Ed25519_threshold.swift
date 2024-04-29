//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation

struct Part: Codable {
    var part: [Data]
    var length: Int
}

struct Ed25519ThresholdV0Share: Codable, Share {
    var index: Int?
    var parts: [Part]?
}

extension Ed25519ThresholdV0Share {
    func getAlgorithm() -> String {
        return Ed25519ThresholdV0().getName()
    }
    
    func serialize() -> [UInt8] {
        do {
            let data = try JSONEncoder().encode(self)
            return Array(data)
        } catch {
            fatalError("Error encoding share: \(error)")
        }
    }
}

func newEd25519ThresholdV0Share(content: [UInt8]) -> Ed25519ThresholdV0Share? {
    do {
        let share = try JSONDecoder().decode(Ed25519ThresholdV0Share.self, from: Data(content))
        return share
    } catch {
        print("Error decoding share: \(error)")
        return nil
    }
}

let maxSecretLen = 31

struct Ed25519ThresholdV0: ThresholdAlgorithm {}

extension Ed25519ThresholdV0 {
    func getName() -> String {
        return "" // Tsed25519의 StringValue return
    }
    
    func dealShares(secret: Secret, threshold: UInt8, total: UInt8) -> [Share] {
        var offset = 0
        
        var tsedShares = [Ed25519ThresholdV0Share](repeating: Ed25519ThresholdV0Share(), count: Int(total))
        
        for index in tsedShares.indices {
            tsedShares[index].index = index + 1
            tsedShares[index].parts = []
        }
        
        while true {
            let length = min(secret.count - offset, maxSecretLen)
            if length == 0 {
                break
            }

            let s = Array(secret[offset ..< offset + length])
            let scalars = tsed25519.dealShares(s, threshold: threshold, total: total) // tsed25519 "gitlab.com/unit410/threshold-ed25519/pkg" 이 모듈이 필요한 것 같다
            guard scalars.count == tsedShares.count else {
                fatalError("Cannot enter here")
            }

            for (index, scalar) in scalars.enumerated() { // index, element 같이 추출
                tsedShares[index].parts.append(Part(scalar: scalar, length: length))
            }

            offset += length
        }
        
        var shares = [Share]()
        for tsedShare in tsedShares {
            if let share = tsedShare as? Share {
                shares.append(share)
            } else {
                fatalError("Cannot convert value of type 'Ed25519ThresholdV0Share' to type 'Share'")
            }
        }

        return shares
    }
    
    func combineShares(shares: [Share], threshold: UInt8, total: UInt8) -> Secret {
        return
    }
}
