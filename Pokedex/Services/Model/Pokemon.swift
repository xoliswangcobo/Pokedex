//
//  Pokemon.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import Foundation

class Pokemon: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: String {
        url.components(separatedBy: "/").dropLast().last ?? ""
    }
    
    var details: PokemonDetail?
}
