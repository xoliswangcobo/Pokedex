//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import Foundation

struct PokemonDetail: Codable {
    let height: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let sprites: PokemonSprites
    let cries: PokemonCries
    let stats: [PokemonStat]
}

struct PokemonAbility: Codable {
    let name: String
    
    enum OuterKey: String, CodingKey {
        case ability
    }

    enum InnerKey: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKey.self)
        let abilityContainer = try container.nestedContainer(keyedBy: InnerKey.self, forKey: .ability)
        name = try abilityContainer.decode(String.self, forKey: .name)
    }
}

struct PokemonSprites: Codable {
    let front: String
    let dreamworld: String
    let officialArtwork: String
    let showdown: String
    
    enum OuterKey: String, CodingKey {
        case front_default
        case other
    }

    enum InnerKey: String, CodingKey {
        case dream_world
        case showdown
        case official
        
        var rawValue: String {
            switch self {
            case .dream_world: return "dream_world"
            case .showdown: return "showdown"
            case .official: return "official-artwork"
            }
        }
    }
    
    enum InnerMostKey: String, CodingKey {
        case front_default
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKey.self)
        front = try container.decode(String.self, forKey: .front_default)
        
        let innerContainer = try container.nestedContainer(keyedBy: InnerKey.self, forKey: .other)
        
        let dreamWorldContainer = try innerContainer.nestedContainer(keyedBy: InnerMostKey.self, forKey: .dream_world)
        dreamworld = try dreamWorldContainer.decode(String.self, forKey: .front_default)
        
        let showdownContainer = try innerContainer.nestedContainer(keyedBy: InnerMostKey.self, forKey: .showdown)
        showdown = try showdownContainer.decode(String.self, forKey: .front_default)
        
        let officialContainer = try innerContainer.nestedContainer(keyedBy: InnerMostKey.self, forKey: .official)
        officialArtwork = try officialContainer.decode(String.self, forKey: .front_default)
    }
}

struct PokemonCries: Codable {
    let latest: String
    let legacy: String
}

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
