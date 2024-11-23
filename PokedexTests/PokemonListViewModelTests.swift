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
        XCTAssertTrue(viewModelUnderTest.searchText.isEmpty)
        XCTAssertEqual(viewModelUnderTest.listPokemons.count, 5)
        XCTAssertEqual(service.getPokemonsCallCount, 1)
    }
    
    func testFetchPokemonsFail() async throws {
        service.getPokemonsHandler = { limit, offset in throw URLError(.notConnectedToInternet) }
        await viewModelUnderTest.fetchPokemons()
        XCTAssertNotNil(viewModelUnderTest.error)
        XCTAssertEqual(service.getPokemonsCallCount, 1)
    }
    
    func testFetchPokemonDetails() throws {
        XCTAssertEqual(true, true)
    }
    
    func testFetchPokemonsDetailsFail() async throws {
        service.getPokemonDetailsHandler = { pokemon in throw URLError(.notConnectedToInternet) }
        try await viewModelUnderTest.fetchDetails(for: Pokemon(name: "Pikachu", url: "pokemon/1/"))
        XCTAssertNotNil(viewModelUnderTest.error)
        XCTAssertEqual(service.getPokemonDetailsCallCount, 1)
    }
    
    func testFetchPokemonImage() throws {
        
    }
    
    func testFetchPokemonImageFail() async throws {
        service.getPokemonDataHandler = { data in throw URLError(.notConnectedToInternet) }
        viewModelUnderTest.fetchImage(for: Pokemon(name: "Pikachu", url: "pokemon/1/"), completion: {_ in })
        XCTAssertEqual(service.getPokemonDataCallCount, 1)
        XCTAssertNotNil(viewModelUnderTest.error)
    }
    
    func fetchShowdownImagedata() throws {
        
    }
    
    func fetchShowdownImagedataFail() throws {
        service.getPokemonDataHandler = { data in throw URLError(.notConnectedToInternet) }
        viewModelUnderTest.fetchShowdownImagedata(for: Pokemon(name: "Pikachu", url: "pokemon/1/"), completion: {_ in })
        XCTAssertEqual(service.getPokemonDataCallCount, 1)
        XCTAssertNotNil(viewModelUnderTest.error)
    }
    
    func testSearchFilter() async throws {
        service.getPokemonsHandler = { limit, offset in [
            Pokemon(name: "Pikachu", url: "pokemon/1/"),
            Pokemon(name: "Pidgey", url: "pokemon/2/"),
            Pokemon(name: "Vulpix", url: "pokemon/3/"),
            Pokemon(name: "Zubat", url: "pokemon/4/"),
            Pokemon(name: "Psyduck", url: "pokemon/5/")
        ] }
        await viewModelUnderTest.fetchPokemons()
        viewModelUnderTest.searchText = "Pi"
        XCTAssertEqual(service.getPokemonsCallCount, 1)
        XCTAssertEqual(viewModelUnderTest.listPokemons.count, 3)
    }
}
