//
//  PokemonListViewModelTests.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/22.
//

import XCTest
import Swinject
@testable import Pokedex

final class PokemonListViewModelTests: XCTestCase {
    
    private var viewModelUnderTest: PokemonListViewModel!
    private var service = PokeAPIServiceMock()
    private var imageCache = ImageCacheMock()
    private var dataCache = DataCacheMock()
    
    override func setUp() {
        let container = Container()
        container.register(PokeAPIService.self) { _ in self.service }
        container.register(ImageCache.self) { _ in self.imageCache }
        container.register(DataCache.self) { _ in self.dataCache }
        Resolver.setContainer(container)
        viewModelUnderTest = PokemonListViewModel()
    }
    
    func testFetchPokemons() async throws {
        service.getPokemonsHandler = { limit, offset in [
            Pokemon(name: "Pikachu", url: "pokemon/1/"),
            Pokemon(name: "Pidgey", url: "pokemon/2/"),
            Pokemon(name: "Vulpix", url: "pokemon/3/"),
            Pokemon(name: "Zubat", url: "pokemon/4/"),
            Pokemon(name: "Psyduck", url: "pokemon/5/")
        ] }
        await viewModelUnderTest.fetchPokemons()
        XCTAssertEqual(viewModelUnderTest.listPokemons.count, 5)
        XCTAssertEqual(service.getPokemonsCallCount, 1)
    }
    
    func testFetchPokemonDetails() throws {
        XCTAssertEqual(true, true)
    }
    
    func testFetchPokemonImage() throws {
        
    }
    
    func fetchShowdownImagedata() throws {
        
    }
    
    func testSearchFilter() throws {
        
    }
}
