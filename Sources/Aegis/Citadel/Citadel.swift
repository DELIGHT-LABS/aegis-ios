//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation
import Alamofire

public struct Fort {
    public let token: String
    public var url: URL
}

public struct PutSecretPayload: Codable {
    public let overwrite: Bool
    public let secret: String
    public let checksum: String
}

public struct PutSecretResponse: Codable {
    public let id: String
}

public struct ErrorResponse: Codable {
    public let error: String
    public let message: String
}

public struct GetSecretResponse: Codable {
    public let secret: String
    public let checksum: String?
}

public class Citadel {
    public var forts: [Fort]
    
    public init(token: String, urls: [URL]) {
        forts = []
        
        urls.forEach { url in
            forts.append(Fort(token: token, url: url))
        }
    }
    
    @available(macOS 10.15, *)
    public func store(payloads: [String], key: Data) async throws {
        guard payloads.count == forts.count else {
            throw NSError(domain: "citadel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Payloads and Fort do not match"])
        }
        
        var responses = [DataTask<PutSecretResponse>]()
        for i in 0..<payloads.count {
            let data = payloads[i]
            let checksum = try Checksum(message: data)
            
            let response = createPutSecretRequest(fort: forts[i], data: data, checksum: checksum, overwrite: true);
            responses.append(response)
        }
        
        for response in responses {
            let res = await response.result
            switch res {
            case .success(_):
                continue
            case .failure(_):
                throw NSError(domain: "citadel", code: 0, userInfo: [NSLocalizedDescriptionKey: "failed to save in citadel"])
            }
        }
    }
    
    @available(macOS 10.15, *)
    public func retrieve(key: Data) async throws -> [String] {
        var responses = [DataTask<GetSecretResponse>]()
        for fort in forts {
            let response = createGetSecretRequest(fort: fort)
            responses.append(response)
        }

        var result: [String] = []
        for response in responses {
            let res = await response.result
            switch res {
            case .success(let r):
                let checksum = try Checksum(message: r.secret)
                if(checksum != r.checksum) {
                    if(!(r.checksum == nil || r.checksum == "")) {
                        throw NSError(domain: "citadel", code: 0, userInfo: [NSLocalizedDescriptionKey: "checksum mismatch"])
                    }
                }
                
                result.append(r.secret)
            case .failure(_):
                continue
            }
        }
        
        return result
    }
    
    @available(macOS 10.15, *)
    public func createPutSecretRequest(fort: Fort, data: String, checksum: String, overwrite: Bool) -> DataTask<PutSecretResponse> {
        let payload = PutSecretPayload(overwrite: overwrite, secret: data, checksum: checksum)
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: fort.token),
            .accept("application/json")
        ]
        let url = URL(string: "\(fort.url)/api/v0/secret")!
        let request = AF.request(url, method: .put, parameters: payload, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: headers) {
            $0.timeoutInterval = 5
        }
        return request.serializingDecodable(PutSecretResponse.self)
    }
    
    @available(macOS 10.15, *)
    public func createGetSecretRequest(fort: Fort) -> DataTask<GetSecretResponse> {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: fort.token),
            .accept("application/json")
        ]
        let url = URL(string: "\(fort.url)/api/v0/secret")!
        let request = AF.request(url, method: .get, headers: headers) {
            $0.timeoutInterval = 5
        }
        
        return request.serializingDecodable(GetSecretResponse.self)
    }
}
