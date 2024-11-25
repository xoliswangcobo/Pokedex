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
    
    let mockPokemon = Pokemon(name: "Pikachu", url: "pokemon/1/", details: PokemonDetail(height: 10,
                                                                                         weight: 10,
                                                                                         abilities: [],
                                                                                         sprites: [
                                                                                            .dreamworld(url: "pokemon/1/dreamworld.png"),
                                                                                            .front(url: "pokemon/1/front.png")
                                                                                         ],
                                                                                         cries: PokemonCries(latest: "", legacy: ""),
                                                                                         stats: [],
                                                                                         types: [.electric]))
    
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
        XCTAssertNil(viewModelUnderTest.error)
    }
    
    func testFetchPokemonsFail() async throws {
        service.getPokemonsHandler = { limit, offset in throw URLError(.notConnectedToInternet) }
        await viewModelUnderTest.fetchPokemons()
        XCTAssertNotNil(viewModelUnderTest.error)
        XCTAssertEqual(service.getPokemonsCallCount, 1)
    }
    
    func testFetchPokemonDetails() async throws {
        service.getPokemonDetailsHandler = { pokemon in
            PokemonDetail(height: 2,
                          weight: 10,
                          abilities: [],
                          sprites: [],
                          cries: PokemonCries(latest: "", legacy: ""),
                          stats: [],
                          types: [.electric])
        }
        await viewModelUnderTest.fetchDetails(for: Pokemon(name: "Pikachu", url: "pokemon/1/"))
        XCTAssertNil(viewModelUnderTest.error)
        XCTAssertEqual(service.getPokemonDetailsCallCount, 1)
    }
    
    func testFetchPokemonsDetailsFail() async throws {
        let pokemon = Pokemon(name: "Pikachu", url: "pokemon/1/")
        service.getPokemonDetailsHandler = { pokemon in throw URLError(.notConnectedToInternet) }
        await viewModelUnderTest.fetchDetails(for: pokemon)
        XCTAssertNotNil(viewModelUnderTest.error)
        XCTAssertEqual(service.getPokemonDetailsCallCount, 1)
        XCTAssertNil(pokemon.details)
    }
    
    func testFetchPokemonImageSaved() throws {
        var imageFetched: UIImage?
        service.getPokemonDataHandler = { _ in Data() }
        imageCache.getImageHandler = { _ in UIImage(systemName: "testtube.2") }
        XCTAssertFalse(mockPokemon.frontSpriteURL?.isEmpty ?? true)
        viewModelUnderTest.fetchImage(for: mockPokemon) { image in imageFetched = image }
        XCTAssertEqual(service.getPokemonDataCallCount, 0)
        XCTAssertNil(viewModelUnderTest.error)
        XCTAssertNotNil(imageFetched)
    }
    
    func testFetchPokemonImageService() throws {
        var imageFetched: UIImage?
        service.getPokemonDataHandler = { _ in UIImage(systemName: "testtube.2")?.pngData() ?? Data() }
        imageCache.getImageHandler = { _ in nil }
        imageCache.setImageHandler = { _, _ in }
        XCTAssertFalse(mockPokemon.frontSpriteURL?.isEmpty ?? true)
        viewModelUnderTest.fetchImage(for: mockPokemon) { image in
            imageFetched = image
            XCTAssertEqual(self.service.getPokemonDataCallCount, 1)
            XCTAssertNil(self.viewModelUnderTest.error)
            XCTAssertNotNil(imageFetched)
        }
    }
    
    func testFetchPokemonImageFail() async throws {
        service.getPokemonDataHandler = { data in throw URLError(.notConnectedToInternet) }
        XCTAssertFalse(mockPokemon.frontSpriteURL?.isEmpty ?? true)
        viewModelUnderTest.fetchImage(for: mockPokemon, completion: {_ in
            XCTAssertEqual(self.service.getPokemonDataCallCount, 1)
            XCTAssertNotNil(self.viewModelUnderTest.error)
        })
    }
    
    func fetchShowdownImagedata() throws {
        service.getPokemonDataHandler = { data in throw URLError(.notConnectedToInternet) }
        viewModelUnderTest.fetchImage(for: Pokemon(name: "Pikachu", url: "pokemon/1/"), completion: {_ in })
        XCTAssertEqual(service.getPokemonDataCallCount, 1)
        XCTAssertNotNil(viewModelUnderTest.error)
    }
    
    func fetchShowdownImagedataFail() throws {
        service.getPokemonDataHandler = { data in throw URLError(.notConnectedToInternet) }
        viewModelUnderTest.fetchShowdownImagedata(for: Pokemon(name: "Pikachu", url: "pokemon/1/"), completion: {_ in })
        XCTAssertEqual(service.getPokemonDataCallCount, 1)
        XCTAssertNotNil(viewModelUnderTest.error)
    }
    
    func testSearchFilter() async throws {
        service.getPokemonsHandler = { limit, offset in [
            Pokemon(name: "Pikachu", url: "pokemon/1/", details: PokemonDetail(height: 10,
                                                                               weight: 10,
                                                                               abilities: [],
                                                                               sprites: [],
                                                                               cries: PokemonCries(latest: "", legacy: ""),
                                                                               stats: [],
                                                                               types: [.electric])),
            Pokemon(name: "Pidgey", url: "pokemon/2/", details: PokemonDetail(height: 1,
                                                                              weight: 5,
                                                                              abilities: [],
                                                                              sprites: [],
                                                                              cries: PokemonCries(latest: "", legacy: ""),
                                                                              stats: [],
                                                                              types: [.flying])),
            Pokemon(name: "Vulpix", url: "pokemon/3/", details: PokemonDetail(height: 3,
                                                                              weight: 50,
                                                                              abilities: [],
                                                                              sprites: [],
                                                                              cries: PokemonCries(latest: "", legacy: ""),
                                                                              stats: [],
                                                                              types: [.fire])),
            Pokemon(name: "Zubat", url: "pokemon/4/", details: PokemonDetail(height: 1,
                                                                             weight: 10,
                                                                             abilities: [],
                                                                             sprites: [],
                                                                             cries: PokemonCries(latest: "", legacy: ""),
                                                                             stats: [],
                                                                             types: [.flying])),
            Pokemon(name: "Psyduck", url: "pokemon/5/")
        ] }
        await viewModelUnderTest.fetchPokemons()
        viewModelUnderTest.searchText = "Pi"
        XCTAssertEqual(service.getPokemonsCallCount, 1)
        XCTAssertEqual(viewModelUnderTest.listPokemons.count, 3)
    }
}
