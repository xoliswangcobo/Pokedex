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
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    var id: String {
        url.components(separatedBy: "/").dropLast().last ?? ""
    }
    
    var details: PokemonDetail?
}

extension Pokemon {
    var dreamWorldSpriteURL: String? {
        return details?.sprites.first(where: { if case .dreamworld = $0 { return true } else { return false } })?.url
    }
    
    var frontSpriteURL: String? {
        return details?.sprites.first(where: { if case .front = $0 { return true } else { return false } })?.url
    }
    
    var officialArtworkSpriteURL: String? {
        return details?.sprites.first(where: { if case .officialArtwork = $0 { return true } else { return false } })?.url
    }
    
    var showsownSpriteURL: String? {
        return details?.sprites.first(where: { if case .showdown = $0 { return true } else { return false } })?.url
    }
}
