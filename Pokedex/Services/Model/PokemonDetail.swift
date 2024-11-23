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
    let sprites: [PokemonSprite]
    let cries: PokemonCries
    let stats: [PokemonStat]
    let types: [PokemonType]
    
    enum Codingkeys: String, CodingKey {
        case height
        case weight
        case abilities
        case sprites
        case cries
        case stats
        case types
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        abilities = try container.decode([PokemonAbility].self, forKey: .abilities)
        cries = try container.decode(PokemonCries.self, forKey: .cries)
        stats = try container.decode([PokemonStat].self, forKey: .stats)
        let spritesContainerDecoded = try container.decode(PokemonSpritesContainer.self, forKey: .sprites)
        sprites = spritesContainerDecoded.sprites
        types = try container.decode([PokemonType].self, forKey: .types)
    }
    
    init(height: Int, weight: Int, abilities: [PokemonAbility], sprites: [PokemonSprite], cries: PokemonCries, stats: [PokemonStat], types: [PokemonType]) {
        self.height = height
        self.weight = weight
        self.abilities = abilities
        self.sprites = sprites
        self.cries = cries
        self.stats = stats
        self.types = types
    }
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

struct PokemonCries: Codable {
    let latest: String
    let legacy: String
}

