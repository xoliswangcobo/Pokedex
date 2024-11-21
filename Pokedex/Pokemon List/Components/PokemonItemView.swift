//
//  PokemonItemView.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import SwiftUI

struct PokemonItemView: View {
    
    @EnvironmentObject var viewModel: PokemonListViewModel
    @State var avatarURL: URL?
    
    var pokemon: Pokemon
    
    var body: some View {
        NavigationLink(destination: PokemonDetailsView(pokemon: pokemon)) {
            HStack {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding()
                } placeholder: {
                    Image("pokeball")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding()
                }
                
                VStack {
                    Text(pokemon.name)
                        .padding()
                    
                    Text(pokemon.id)
                        .padding()
                }
            }
            .task {
                if pokemon.details == nil {
                    do {
                        let details = try await viewModel.fetchDetails(for: pokemon)
                        await MainActor.run {
                            self.pokemon.details = details
                            self.avatarURL = URL(string: details.sprites.front)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
