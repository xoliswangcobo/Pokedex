//
//  PokemonItemView.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import SwiftUI

struct PokemonItemView: View {
    
    @EnvironmentObject var viewModel: PokemonListViewModel
    @State var avatar: Image?
    @State var showdownAvatar: Data?
    @State var typeColor: Color?
    
    var pokemon: Pokemon
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: PokemonDetailsView(showdownSprite: $showdownAvatar, pokemon: pokemon)) { EmptyView() }.opacity(0)
            
            HStack {
                if let avatar {
                    avatar
                        .resizable()
                        .frame(width: 80, height: 80)
                        .background(.gray)
                        .clipShape(Circle())
                    
                } else {
                    Image("pokeball")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .background(.gray)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                VStack {
                    Text(pokemon.name.capitalized).fontWeight(.semibold)
                        .padding(.trailing, 16)
                }
            }
            .padding(8)
            .background(typeColor ?? .blue.opacity(0.2))
            .cornerRadius(12)
        }
        .onError(error: $viewModel.error, title: "Pokedex", actions: [ ("Okay", {}) ])
        .onAppear {
            Task {
                if pokemon.details == nil {
                    await viewModel.fetchDetails(for: pokemon)
                }
                
                if let typeColor = pokemon.details?.types.first?.colorHex {
                    self.typeColor = Color(hex: typeColor)
                }
                
                viewModel.fetchImage(for: pokemon) { image in
                    DispatchQueue.main.async {
                        self.avatar = Image(uiImage: image)
                    }
                }
                
                viewModel.fetchShowdownImagedata(for: pokemon) { data in
                    self.showdownAvatar = data
                }
            }
        }
        
    }
}
