//
//  HTTPMethod.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
    case other
    
    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        case .other: return "OPTIONS"
        }
    }
}
