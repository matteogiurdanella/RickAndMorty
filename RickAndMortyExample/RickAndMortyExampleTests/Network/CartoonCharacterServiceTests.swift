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
    // Given
    networkService.responseType = .characterList
    
    // When
    let pageModel = try await sut.fetchCharacters(page: 1).get()
    
    // Then
    #expect(pageModel.info.count == 826)
    #expect(pageModel.info.pages == 42)
    #expect(pageModel.info.next == "https://rickandmortyapi.com/api/character?page=2")
    #expect(pageModel.info.prev == nil)
    #expect(pageModel.results.count == 20)
    #expect(networkService.invocation == [.fetch(endpoint: "character", queryItems: ["page": "1"])])
  }
  
  @Test
  func fetchCharacterById() async throws {
    // Given
    networkService.responseType = .characterDetail
    
    // When
    let character = try await sut.fetchCharacter(by: 1).get()
    
    // Then
    #expect(character.id == 1)
    #expect(networkService.invocation == [.fetch(endpoint: "character/1", queryItems: [:])])
  }
  
  @Test
  func throwError() async throws {
    // Given
    let error: NetworkError = .invalidData
    networkService.throwError = error
    
    // When
    let result = await sut.fetchCharacter(by: 1)
    
    // Then
    switch result {
    case .success:
      Issue.record("Expected Failure")
    case let .failure(callError):
      #expect((callError as? NetworkError)?.errorDescription == error.errorDescription)
    }
    #expect(networkService.invocation == [.fetch(endpoint: "character/1", queryItems: [:]), .error(error)])
  }
}
