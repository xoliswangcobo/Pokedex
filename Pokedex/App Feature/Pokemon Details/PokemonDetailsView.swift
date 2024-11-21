//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import SwiftUI
import WebKit

struct PokemonDetailsView: View {
    
    @Binding var showdownSprite: Data?
    var pokemon: Pokemon
    private let useWebView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                if let showdownSprite {
                    if useWebView, let showdownSpriteURL = pokemon.showsownSpriteURL {
                        GifImageWebView(showdownSprite, url: showdownSpriteURL)
                            .frame(width: 300, height: 300)
                    } else {
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
                        
                        
                    }
                } else {
                    ProgressView()
                }
                
                Spacer()
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.large)
        
    }
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
