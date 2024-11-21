//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import SwiftUI
import WebKit

struct PokemonDetailsView: View {
    
    var pokemon: Pokemon
    var url: URL? { URL(string: pokemon.details?.sprites.front ?? "") }
    
    var body: some View {
        VStack {
            GifImageView(pokemon.details?.sprites.showdown ?? "")
                .frame(width: 300, height: 300)
        }
        .navigationTitle(pokemon.name)
    }
}

struct GifImageView: UIViewRepresentable {
    
    private let url: String
    
    init(_ url: String) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else { return WKWebView() }
        
        let webview = WKWebView()
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
