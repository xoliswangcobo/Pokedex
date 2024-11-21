//
//  PokemonList.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import SwiftUI

struct PokemonList: View {
    @StateObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.pokemons) { pokemon in
                    PokemonItemView(pokemon: pokemon)
                        .environmentObject(viewModel)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Rectangle()
                                .fill(Color.blue.opacity(0.2))
                                .cornerRadius(10.0)
                                .padding(.vertical, 4.0)
                                .padding(.horizontal, 16.0)
                        )
                }
            }
            .navigationTitle("Pokemons")
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .listBackground(.white)
        .task {
            await viewModel.fetchPokemons()
        }
        .refreshable {
            await viewModel.fetchPokemons()
        }
    }
}

#Preview {
    PokemonList()
}
