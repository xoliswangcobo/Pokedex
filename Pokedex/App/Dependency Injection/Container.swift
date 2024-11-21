//
//  Container.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/21.
//

import Swinject

func buildContainer() -> Container {
    
    let container = Container()
    
    container.register(DataCache.self) { _  in
        return DataCacheImplementation.shared
    }.inObjectScope(.container)
    
    container.register(ImageCache.self) { _  in
        return ImageCacheImplementation.shared
    }.inObjectScope(.container)
    
    container.register(PokeAPIService.self) { _  in
        return PokeAPIServiceImplementation()
    }.inObjectScope(.container)
    
    container.register(PokeAPIClient.self) { _  in
        return PokeAPIClientImplementation()
    }
    
    return container
}
