//
//  GetPokemonsRequest.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import Foundation

struct GetPokemonsRequest: PokeAPIRequest {

    var urlParameters: [String : String]
    var path: String { "pokemon" }
    
    init(limit: Int = 100, offset: Int = 0) {
        urlParameters = [ "limit": "\(limit)", "offset": "\(offset)"]
    }
    
}
