//
//  Inject.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//
// Source: https://paulallies.medium.com/swift-dependency-injection-with-swinject-ad17e33c3910

@propertyWrapper
struct Inject<I> {
    
    let wrappedValue: I
    
    init() {
        self.wrappedValue = Resolver.shared.resolve(I.self)
    }
}
