//
//  PokemonList.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/19.
//

import SwiftUI

struct PokemonList: View {
    
    @StateObject var viewModel = PokemonListViewModel()
    @State var searchIsActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.listPokemons) { pokemon in
                    PokemonItemView(pokemon: pokemon)
                        .environmentObject(viewModel)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Rectangle()
                                .fill(.clear)
                                .cornerRadius(10.0)
                                .padding(.vertical, 4.0)
                                .padding(.horizontal, 16.0)
                        )
                }
            }
            .navigationTitle("Pokemons")
        }
        .searchable(text: $viewModel.searchText)
        .tint(.green)
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
