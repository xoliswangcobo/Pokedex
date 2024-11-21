//
//  PokemonTypesContainer.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//

enum PokemonType: String, Codable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case other
    
    var colorHex: String {
        switch self {
        case .normal:
            return "9099a1"
        case .fighting:
            return "ffac59"
        case .flying:
            return "ffac59"
        case .poison:
            return "ffac59"
        case .ground:
            return "b78e6f"
        case .rock:
            return "cbc7ad"
        case .bug:
            return "b8c26a"
        case .ghost:
            return "a284a2"
        case .steel:
            return "97c2d1"
        case .fire:
            return "ef7375"
        case .water:
            return "74abf5"
        case .grass:
            return "82c274"
        case .electric:
            return "fcd659"
        case .psychic:
            return "f584a7"
        case .ice:
            return "80dff7"
        case .dragon:
            return "8d98ec"
        case .dark:
            return "9a8a8c"
        case .fairy:
            return "f5a2f5"
        case .other:
            return "83cfc5"
        }
    }
}

struct PokemonTypesContainer: Codable {
    let type: PokemonType
    
    enum OuterKey: String, CodingKey {
        case type
    }

    enum InnerKey: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKey.self)
        let theTypeContainer = try container.nestedContainer(keyedBy: InnerKey.self, forKey: .type)
        let theType = try theTypeContainer.decode(String.self, forKey: .name)
        type = PokemonType(rawValue: theType) ?? .other
    }
}
