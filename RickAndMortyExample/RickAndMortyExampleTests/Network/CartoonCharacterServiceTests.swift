//
//  CartoonCharacterServiceTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Testing
@testable import RickAndMortyExample

final class CartoonCharacterServiceTests {
  let networkService = MockNetworkService()
  lazy var sut = CartoonCharacterService(networkService: networkService)
  
  @Test
  func fetchCharacterList() async throws {
    networkService.responseType = .characterList
    let pageModel = try? await sut.fetchCharacters()
    #expect(pageModel?.info.count == 826)
    #expect(pageModel?.info.pages == 42)
    #expect(pageModel?.info.next == "https://rickandmortyapi.com/api/character?page=2")
    #expect(pageModel?.info.prev == nil)
    #expect(pageModel?.results.count == 20)
    #expect(networkService.invocation == [.fetch(endpoint: "character")])
  }
  
  @Test
  func fetchCharacterById() async throws {
    networkService.responseType = .characterDetail
    let character = try? await sut.fetchCharacters(id: 1)
    #expect(character != nil)
    #expect(networkService.invocation == [.fetch(endpoint: "character/1")])
  }
  
  @Test
  func throwError() async throws {
    let error: NetworkError = .invalidData
    networkService.throwError = error
    let character = try? await sut.fetchCharacters(id: 1)
    #expect(character == nil)
    #expect(networkService.invocation == [.fetch(endpoint: "character/1"), .error(error)])
  }
}
