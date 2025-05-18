//
//  CartoonCharacterListViewModelTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Foundation
import Testing
@testable import RickAndMortyExample

struct CartoonCharacterListViewModelTests {
  
  @Test
  func cartoonCharactersOnAppear() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // Then
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
    
    // When - calling again Fetch On Appear
    await viewModel.fetchCartoonCharactersOnAppear()

    // Then - No Changes are expected
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
  }
  
  @Test
  func fetchCartoonCharactersFailsWithNetworkError() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.throwError = NetworkError.invalidURL
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // Then
    #expect(viewModel.characters.isEmpty)
    #expect(viewModel.errorMessage == NetworkError.invalidURL.errorDescription)
    #expect(viewModel.isLoading == false)
  }
  
  @Test
  func fetchCartoonCharactersFailsWithUnknownError() async throws {
    // Given
    let error = NSError(domain: "Test", code: 1)
    let mockNetworkService = MockNetworkService()
    mockNetworkService.throwError = error
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // Then
    #expect(viewModel.characters.isEmpty)
    #expect(viewModel.errorMessage != nil)
    #expect(viewModel.isLoading == false)
  }
  
  @Test
  func filteredCharactersWhenSearchTextEmptyReturnsAll() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // When
    viewModel.searchText = ""
    
    // Then
    #expect(viewModel.filteredCharacters.count == viewModel.characters.count)
  }
  
  @Test
  func filteredCharactersFiltersByName() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // When
    viewModel.searchText = "Mort"
    
    // Then
    let result = viewModel.filteredCharacters
    #expect(result.count == 3)
    #expect(result.first?.name == "Morty Smith")
  }
  
  @Test
  func filteredCharactersFiltersByOtherFields() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // When
    viewModel.searchText = "avian"
    // Then
    #expect(viewModel.filteredCharacters.count == 0)
    
    // When
    viewModel.searchText = "Be"
    // Then
    #expect(viewModel.filteredCharacters.first?.name == "Beth Smith")
    #expect(viewModel.filteredCharacters.last?.name == "Albert Einstein")
    
    // When
    viewModel.searchText = "Dead"
    // Then
    #expect(viewModel.filteredCharacters.count == 6)
  }
  
  @Test
  func fecthCartoonCharactersOnRetry() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharactersOnRetry()
    
    // Then
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
    
    // When - called retry again
    await viewModel.fetchCartoonCharactersOnRetry()
    
    // Then - I should expect the same result
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
  }
  
  @Test
  func fecthCartoonCharactersOnRefresh() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharactersOnRefresh()
    
    // Then
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
    
    // When - called retry again
    await viewModel.fetchCartoonCharactersOnRefresh()
    
    // Then - I should expect the same result
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
  }
  
  @Test
  func fecthMoreCharacterIfNeeded() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When - I first load
    await viewModel.fetchCartoonCharactersOnAppear()
    
    // Then - I have 3 Morty
    #expect(viewModel.characters.count == 20)
    #expect(viewModel.characters.filter({ $0.name.contains("Morty") }).count == 3)

    // Given - the last 5th character
    guard let character = viewModel.characters.first(where: { $0.id == 16 }) else {
      Issue.record("Last Character not found")
      return
    }
    
    // When - I call for more Character
    await viewModel.fetchMoreCharactersIfNeeded(character)
    
    // Then - I have double every character
    #expect(viewModel.characters.count == 40)
    #expect(viewModel.characters.filter({ $0.name.contains("Morty") }).count == 6)
    
    // Given - an element in the middle of the array
    guard let lastCharacter = viewModel.characters.first(where: { $0.id == 20 }) else {
      Issue.record("Character in the middle not found")
      return
    }
    
    // When - I call for more Character
    await viewModel.fetchMoreCharactersIfNeeded(lastCharacter)
    
    // Then - It should not change anything because I am not at the end of the list
    #expect(viewModel.characters.count == 40)
    #expect(viewModel.characters.filter({ $0.name.contains("Morty") }).count == 6)
  }
}
