//
//  PokeAPIRequest.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import Foundation

/// @mockable
protocol PokeAPIRequest {
    
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var urlParameters: [String: String] { get set }
    var bodyParameters: [String: Any] { get set }
    var httpHeaders: [String: String] { get set }
}

extension PokeAPIRequest {
    
    var httpMethod: HTTPMethod { .get }
    
    var urlParameters: [String: String] {
        get { [:] }
        set { }
    }
    
    var bodyParameters: [String: Any] {
        get { [:] }
        set { }
    }
    
    var httpHeaders: [String: String] {
        get { [:] }
        set { }
    }
}
