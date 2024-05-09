//
//  File.swift
//  
//
//  Created by 박시현 on 4/29/24.
//

import Foundation
import Alamofire

struct Fort {
    let token: String
    var url: URL
}

struct PutSecretPayload: Codable {
    let overwrite: Bool
    let secret: String
}

struct PutSecretResponse: Codable {
    let id: String
}

struct ErrorResponse: Codable {
    let error: String
    let message: String
}

struct GetSecretResponse: Codable {
    let secret: String
}

class Citadel {
    var forts: [Fort]
    
    init(token: String, urls: [URL]) {
        forts = []
        
        urls.forEach { url in
            forts.append(Fort(token: token, url: url))
        }
    }
    
    @available(macOS 10.15, *)
    func store(payloads: [Data], key: Data) async throws {
        guard payloads.count == forts.count else {
            throw NSError(domain: "citadel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Payloads and Fort do not match"])
        }
        
        let strKey = key.base64EncodedString()
        var responses = [DataTask<PutSecretResponse>]()
        for i in 0..<payloads.count {
            let data = payloads[i].base64EncodedString()
            
            let response = createPutSecretRequest(fort: forts[i], data: data, overwrite: true);
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
    func retrieve(key: Data) async -> [payload] {
        let strKey = key.base64EncodedString()
        
        var responses = [DataTask<GetSecretResponse>]()
        for fort in forts {
            let response = createGetSecretRequest(fort: fort)
            responses.append(response)
        }

        var result: [payload] = []
        for response in responses {
            let res = await response.result
            switch res {
            case .success(let r):
                let encodedSecret = r.secret
                let secret = Data(base64Encoded: encodedSecret)!
                result.append(secret)
            case .failure(_):
                continue
            }
        }
        
        return result
    }
    
    @available(macOS 10.15, *)
    private func createPutSecretRequest(fort: Fort, data: String, overwrite: Bool) -> DataTask<PutSecretResponse> {
        let payload = PutSecretPayload(overwrite: overwrite, secret: data)
        
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
    private func createGetSecretRequest(fort: Fort) -> DataTask<GetSecretResponse> {
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
