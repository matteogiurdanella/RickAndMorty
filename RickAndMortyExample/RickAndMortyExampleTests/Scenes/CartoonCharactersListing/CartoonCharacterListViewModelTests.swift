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
  func cartoonCharactersSuccess() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharacters()
    
    // Then
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
    await viewModel.fetchCartoonCharacters()
    
    // Then
    #expect(viewModel.characters.isEmpty)
    #expect(viewModel.errorMessage == NetworkError.invalidURL.errorDescription)
    #expect(viewModel.isLoading == false)
  }
  
  @Test
  func testFetchCartoonCharactersFailsWithUnknownError() async throws {
    // Given
    let error = NSError(domain: "Test", code: 1)
    let mockNetworkService = MockNetworkService()
    mockNetworkService.throwError = error
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    
    // When
    await viewModel.fetchCartoonCharacters()
    
    // Then
    #expect(viewModel.characters.isEmpty)
    #expect(viewModel.errorMessage != nil)
    #expect(viewModel.isLoading == false)
  }
  
  @Test
  func testFilteredCharactersWhenSearchTextEmptyReturnsAll() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    await viewModel.fetchCartoonCharacters()
    
    // When
    viewModel.searchText = ""
    
    // Then
    #expect(viewModel.filteredCharacters.count == viewModel.characters.count)
  }
  
  @Test
  func testFilteredCharactersFiltersByName() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    await viewModel.fetchCartoonCharacters()
    
    // When
    viewModel.searchText = "Mort"
    
    // Then
    let result = viewModel.filteredCharacters
    #expect(result.count == 3)
    #expect(result.first?.name == "Morty Smith")
  }
  
  @Test
  func testFilteredCharactersFiltersByOtherFields() async throws {
    // Given
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterList
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterListViewModel(charactersService: mockService)
    await viewModel.fetchCartoonCharacters()
    
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
}
