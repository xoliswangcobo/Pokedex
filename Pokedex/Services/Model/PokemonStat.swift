//
//  PokemonStat.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//

import Foundation

struct PokemonStat: Codable {
    let baseStat: Int
    let name: String
    
    enum OuterKey: String, CodingKey {
        case stat
        case base_stat
    }

    enum InnerKey: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKey.self)
        let statContainer = try container.nestedContainer(keyedBy: InnerKey.self, forKey: .stat)
        name = try statContainer.decode(String.self, forKey: .name)
        baseStat = try container.decode(Int.self, forKey: .base_stat)
    }
}
