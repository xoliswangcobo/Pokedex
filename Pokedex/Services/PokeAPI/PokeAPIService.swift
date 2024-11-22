//
//  PokeAPIService.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import Foundation

/// @mockable
protocol PokeAPIService {
    
    func getPokemons(limit: Int, offset: Int) async throws -> [Pokemon]
    func getPokemonDetails(pokemon: Pokemon) async throws -> PokemonDetail
    func getPokemonData(url: String) async throws -> Data
    
}

extension PokeAPIService {
    
    func getPokemons() async throws -> [Pokemon] {
        return try await getPokemons(limit: 100, offset: 0)
    }
}

class PokeAPIServiceImplementation: PokeAPIService {
    
    @Inject private var apiClient: PokeAPIClient
    
    func getPokemons(limit: Int, offset: Int) async throws -> [Pokemon] {
        let request = GetPokemonsRequest()
        do {
            let response = try await apiClient.request(request) as GetPokemonsResponse
            return  response.results
        } catch {
            throw error
        }
    }
    
    func getPokemonDetails(pokemon: Pokemon) async throws -> PokemonDetail {
        let request = GetPokemonDetailRequest(id: pokemon.id)
        do {
            return try await apiClient.request(request)
        } catch {
            throw error
        }
    }
    
    func getPokemonData(url: String) async throws -> Data {
        guard let resourceURL = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        do {
            let request = URLRequest(url: resourceURL)
            return try await apiClient.request(request)
        } catch {
            throw error
        }
    }
    
}
