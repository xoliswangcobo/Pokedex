//
//  APIConfig.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

enum APIConfig {
    case baseURL
    case authURL
    
    var rawValue: String {
        switch self {
        case .baseURL: 
            return "https://pokeapi.co/api/v2/"
        case .authURL:
            return ""
        }
    }
}
