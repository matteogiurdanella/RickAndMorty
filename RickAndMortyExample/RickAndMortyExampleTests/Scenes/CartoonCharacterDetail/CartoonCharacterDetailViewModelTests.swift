//
//  CartoonCharacterDetailViewModelTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Testing
import UIKit
@testable import RickAndMortyExample

struct CartoonCharacterDetailViewModelTests {
  @Test
  func fetchCharacterSuccessAndLoadsImage() async throws {
    // Given
    let imageService = MockImageService()
    imageService.result = .success(UIImage())
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterDetail
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterDetailViewModel(
      cartoonCharacterService: mockService,
      imageService: imageService
    )
    
    // When
    await viewModel.fetchCharacter(id: 1)
    try await TestWait.until(
      object: viewModel,
      keyPath: \CartoonCharacterDetailViewModel.postImage,
      where: { $0 != nil }
    )
    
    // Then
    #expect(viewModel.character?.name == "Rick Sanchez")
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
    #expect(viewModel.postImage != nil)
    #expect(viewModel.isImageLoading == false)
    #expect(
      mockNetworkService.invocation == [.fetch(endpoint: "character/1", queryItems: [:])]
    )
  }
  
  @Test
  func fetchCharacterFailsWithNetworkError() async throws {
    // Given
    let imageService = MockImageService()
    let mockNetworkService = MockNetworkService()
    mockNetworkService.throwError = NetworkError.invalidURL
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterDetailViewModel(
      cartoonCharacterService: mockService,
      imageService: imageService
    )
    
    // When
    await viewModel.fetchCharacter(id: 2)
    
    // Then
    #expect(viewModel.character == nil)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == NetworkError.invalidURL.errorDescription)
    #expect(mockNetworkService.invocation == [
      .fetch(endpoint: "character/2", queryItems: [:]),
      .error(NetworkError.invalidURL)
    ])
  }
  
  @Test
  func fetchCharacterFailsWithGenericError() async throws {
    // Given
    let imageService = MockImageService()
    let error: Error = NSError(domain: "Test", code: 1)
    let mockNetworkService = MockNetworkService()
    mockNetworkService.throwError = error
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    
    let viewModel = CartoonCharacterDetailViewModel(
      cartoonCharacterService: mockService,
      imageService: imageService
    )
    
    // When
    await viewModel.fetchCharacter(id: 3)
    
    // Then
    #expect(viewModel.character == nil)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage != nil)
    #expect(mockNetworkService.invocation == [
      .fetch(endpoint: "character/3", queryItems: [:]),
      .error(error)
    ])
  }
  
  @Test
  func imageLoadingStateChanges() async throws {
    // Given
    let imageService = MockImageService()
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterDetail
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    let viewModel = CartoonCharacterDetailViewModel(
      cartoonCharacterService: mockService,
      imageService: imageService
    )
    
    // When
    let task = Task { await viewModel.fetchCharacter(id: 1) }
    try await Task.sleep(nanoseconds: 100_000_000)
    
    // Then
    #expect(viewModel.isImageLoading == false)
    task.cancel()
  }
  
  @Test
  func deinitCancelsImageTask() async throws {
    // Given
    let imageService = MockImageService()
    let mockNetworkService = MockNetworkService()
    mockNetworkService.responseType = .characterDetail
    let mockService = CartoonCharacterService(networkService: mockNetworkService)
    var viewModel: CartoonCharacterDetailViewModel? = CartoonCharacterDetailViewModel(
      cartoonCharacterService: mockService,
      imageService: imageService
    )
    await viewModel?.fetchCharacter(id: 1)

    // When: Trigger Deinit
    viewModel = nil
    
    // Then: If no crash and test ends cleanly
    #expect(true)
  }
}

