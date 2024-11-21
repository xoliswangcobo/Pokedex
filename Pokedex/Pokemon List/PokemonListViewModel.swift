//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import Foundation
import Combine
import UIKit

class PokemonListViewModel: ObservableObject {
    
    // Injection
    private let service: PokeAPIService = PokeAPIServiceImplementation()
    
    @Published var pokemons: [Pokemon] = []
    
    func fetchPokemons() async {
        do {
            let newPokemons = try await service.getPokemons()
            await MainActor.run {
                self.pokemons = newPokemons
            }
        } catch {
            print(error)
        }

    }
    
    func fetchDetails(for pokemon: Pokemon) async throws -> PokemonDetail {
        try await service.getPokemonDetails(pokemon: pokemon)
    }
    
    func fetchImage(for pokemon: Pokemon, completion: @escaping (UIImage) -> Void) {
        guard let url = pokemon.details?.sprites.officialArtwork else { return }
        
        Task {
            do {
                let data = try await service.getPokemonData(url: url)
                completion(UIImage(data: data) ?? UIImage(named: "pokeball")!)
            } catch {
                print(error)
            }
        }
    }
}
