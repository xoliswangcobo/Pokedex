//
//  Pokedex+URLRequest.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//
import Foundation

extension URLRequest {
    
    init(from request: PokeAPIRequest) {
        
        let endPoint: URL = URL(string: APIConfig.baseURL.rawValue)!
        guard var components = URLComponents(url: endPoint.appendingPathComponent(request.path),
                                             resolvingAgainstBaseURL: false) else {
            fatalError("Failed to create URL components")
        }
        
        if !request.urlParameters.isEmpty {
            components.queryItems = request.urlParameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        components.percentEncodedQuery = components
            .percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")

        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        self = .init(url: url)
        
        httpMethod = request.httpMethod.rawValue
        
        switch request.httpMethod {
        case .post, .put, .patch:
            httpBody = try? JSONSerialization.data(withJSONObject: request.bodyParameters)
        default:
            break
        }
        
        timeoutInterval = 30.0
        cachePolicy = .useProtocolCachePolicy
        
        // Request Headers
        addValue("en;q=1", forHTTPHeaderField: "Accept-Language")
        addValue("Pokedex", forHTTPHeaderField: "Application-Name")
        addValue("iOS", forHTTPHeaderField: "Application-Platform")
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpHeaders.forEach { addValue($0.value, forHTTPHeaderField: $0.key) }
    }
    
}
