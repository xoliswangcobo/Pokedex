//
//  Resolver.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//
// Source: https://paulallies.medium.com/swift-dependency-injection-with-swinject-ad17e33c3910

import Swinject

class Resolver {
    static let shared = Resolver()
    
    //get the IOC container
    private var container = buildContainer()
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}
