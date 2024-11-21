//
//  PokemonSpritesContainer.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//

import Foundation


enum PokemonSprite: Codable {
    case front(url: String)
    case dreamworld(url: String)
    case officialArtwork(url: String)
    case showdown(url: String)
    
    var url: String {
        switch self {
        case .front(let url):
            return url
        case .dreamworld(let url):
            return url
        case .officialArtwork(let url):
            return url
        case .showdown(let url):
            return url
        }
    }
}


struct PokemonSpritesContainer: Codable {
    let sprites: [PokemonSprite]
        
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
        let front = try container.decode(String.self, forKey: .front_default)
        
        let innerContainer = try container.nestedContainer(keyedBy: InnerKey.self, forKey: .other)
        
        let dreamWorldContainer = try innerContainer.nestedContainer(keyedBy: InnerMostKey.self, forKey: .dream_world)
        let dreamworld = try dreamWorldContainer.decode(String.self, forKey: .front_default)
        
        let showdownContainer = try innerContainer.nestedContainer(keyedBy: InnerMostKey.self, forKey: .showdown)
        let showdown = try showdownContainer.decode(String.self, forKey: .front_default)
        
        let officialContainer = try innerContainer.nestedContainer(keyedBy: InnerMostKey.self, forKey: .official)
        let officialArtwork = try officialContainer.decode(String.self, forKey: .front_default)
        
        sprites = [ PokemonSprite.front(url: front),
                    PokemonSprite.dreamworld(url: dreamworld),
                    PokemonSprite.showdown(url: showdown),
                    PokemonSprite.officialArtwork(url: officialArtwork) ]
    }
}
