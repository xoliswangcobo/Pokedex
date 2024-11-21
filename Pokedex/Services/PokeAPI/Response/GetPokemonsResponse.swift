//
//  GetPokemonsResponse.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import Foundation

struct GetPokemonsResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
