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
    @State var showdownAvatar: Data?
    
    var pokemon: Pokemon
    
    var body: some View {
        NavigationLink(destination: PokemonDetailsView(showdownSprite: $showdownAvatar, pokemon: pokemon)) {
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
                        try await viewModel.fetchDetails(for: pokemon)
                        
                        await MainActor.run {
                            if let url = pokemon.frontSpriteURL {
                                self.avatarURL = URL(string: url)
                            }
                        }
                        
                        viewModel.fetchShowdownImagedata(for: pokemon) { data in
                           self.showdownAvatar = data
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
