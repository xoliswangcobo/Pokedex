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
    private let imageCache: ImageCache = ImageCacheImplementation.shared
    private let dataCache = DataCacheImplementation.shared
    
    @Published var pokemons: [Pokemon] = []
    @Published var error: Error?
    
    func fetchPokemons() async {
        do {
            let newPokemons = try await service.getPokemons()
            await MainActor.run {
                self.pokemons = newPokemons
            }
        } catch {
            self.error = error
        }
    }
    
    func fetchDetails(for pokemon: Pokemon) async throws {
        let details = try await service.getPokemonDetails(pokemon: pokemon)
        pokemon.details = details
    }
    
    func fetchImage(for pokemon: Pokemon, completion: @escaping (UIImage) -> Void) {
        guard let url = pokemon.frontSpriteURL else { return }
        
        if let image = imageCache.getImage(forKey: url) {
            completion(image)
        } else {
            Task {
                do {
                    let data = try await service.getPokemonData(url: url)
                    if let image = UIImage(data: data) {
                        imageCache.setImage(image, forKey: url)
                        completion(image)
                    } else {
                        completion(UIImage(named: "pokeball")!)
                    }
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    func fetchShowdownImagedata(for pokemon: Pokemon, completion: @escaping (Data) -> Void) {
        guard let url = pokemon.showsownSpriteURL else { return }
        
        if let data = dataCache.getData(forKey: url) {
            completion(data)
        } else {
            Task {
                do {
                    let data = try await service.getPokemonData(url: url)
                    dataCache.setData(data, forKey: url)
                    completion(data)
                } catch {
                    self.error = error
                }
            }
        }
    }
}
