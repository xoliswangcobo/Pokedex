//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import SwiftUI
import WebKit
import SDWebImageSwiftUI

struct PokemonDetailsView: View {
    
    @Binding var showdownSprite: Data?
    var pokemon: Pokemon
    private let useView = PlayerChoice.animatedimage
    
    var body: some View {
        ScrollView {
            VStack {
                if let showdownSprite {
                    switch useView {
                    case .webview:
                        if let showdownSpriteURL = pokemon.showsownSpriteURL {
                            GifImageWebView(showdownSprite, url: showdownSpriteURL)
                                .frame(width: 300, height: 300)
                                .padding(16)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 3)
                                )
                                .padding(16)
                                .padding(.bottom, 24)
                        } else {
                            ProgressView()
                        }
                    case .imagerenderer:
                        GifImageView(showdownSprite)
                            .frame(width: 300, height: 300)
                            .padding(16)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 3)
                            )
                            .padding(16)
                            .padding(.bottom, 24)
                    case .animatedimage:
                        AnimatedImage(data: showdownSprite)
                            .frame(width: 300, height: 300)
                            .padding(16)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 3)
                            )
                            .padding(16)
                    }
                } else {
                    ProgressView()
                }
                
                HStack {
                    if let stats = pokemon.details?.stats {
                        VStack {
                            Text("Stats")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .padding(.top, 16)
                            
                            ForEach(stats, id: \.name) { pokemonStat in
                                HStack {
                                    Text(pokemonStat.name.capitalized)
                                        .font(.subheadline)
                                        .padding(.trailing, 16)
                                    
                                    Spacer()
                                    
                                    Text("\(pokemonStat.baseStat)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding(.leading, 16)
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            Spacer()
                        }.frame(minWidth: 120, maxWidth: .infinity)
                    }
                    
                    VStack {
                        Text("Height")
                            .font(.subheadline)
                            .padding(.top, 16)
                        Text("\(pokemon.details?.height ?? 0)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, 16)
                        Text("Weight")
                            .font(.subheadline)
                        Text("\(pokemon.details?.weight ?? 0)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 16)
                    }.frame(maxWidth: 120)
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: pokemon.details?.types.first?.colorHex ?? "D3D3D3").opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(16)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.large)
        
    }
}

fileprivate enum PlayerChoice {
    case webview
    case imagerenderer
    case animatedimage
}

fileprivate struct GifImageWebView: UIViewRepresentable {
    
    private let data: Data
    private let url: String
    
    init(_ data: Data, url: String) {
        self.data = data
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.scrollView.isScrollEnabled = false
        webview.scrollView.panGestureRecognizer.isEnabled = false
        webview.scrollView.bounces = false
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: URL(string: url)!)
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

fileprivate struct GifImageView: View {
    
    @State private var gifImage: Image?
    private let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    var body: some View {
        VStack {
            if let gifImage {
                gifImage
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            CGAnimateImageDataWithBlock(data as CFData, nil) { index, cgImage, stop in
                self.gifImage = Image(uiImage: .init(cgImage: cgImage))
            }
            
        }
    }
}
