//
//  PokeAPIClient.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//
import Foundation

protocol PokeAPIClient {
    
    func request(_ request: URLRequest) async throws -> Data
    func request(_ request: PokeAPIRequest) async throws -> Data
    func request<T: Decodable>(_ request: PokeAPIRequest) async throws -> T
    
}

class PokeAPIClientImplementation: PokeAPIClient {
    
    func request(_ request: URLRequest) async throws -> Data {
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "PokeAPI - Server Connection Error", code: 500, userInfo: nil)
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Request URL: \(request.url?.absoluteString ?? "No URL"), Response: \(String(decoding: data, as: UTF8.self))")
                return data
            }
            
            if (400...499).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }
            
            throw NSError(domain: "PokeAPI - \(httpResponse.statusCode)", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "\(httpResponse.statusCode) - \(response.debugDescription)"])
        } catch {
            throw error
        }
    }
    
    func request(_ request: PokeAPIRequest) async throws -> Data {
        try await self.request(URLRequest(from: request))
    }
    
    func request<T>(_ request: PokeAPIRequest) async throws -> T where T : Decodable {
        do {
            let data: Data = try await self.request(request)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
}
