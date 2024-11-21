//
//  GetPokemonDetailRequest.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import Foundation

struct GetPokemonDetailRequest: PokeAPIRequest {

    var path: String
    
    init(id: String) {
        path = "pokemon/\(id)"
    }
    
}
