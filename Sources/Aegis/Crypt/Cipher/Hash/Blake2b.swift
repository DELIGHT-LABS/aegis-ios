//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation
import Blake2

public func Blake2b(size: Int, message: Data) throws -> Data {
    return try Blake2b.hash(size: size, data: message)
}
