//
//  CartoonCharacterCellPhotoViewModelTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Testing
import UIKit
@testable import RickAndMortyExample

struct CartoonCharacterCellPhotoViewModelTests {
  
  @Test
  func imageLoadsSuccessfully() async throws {
    // Given
    let mockImageService = MockImageService()
    mockImageService.result = .success(UIImage())
    
    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )
    
    // When
    await MainActor.run { viewModel.loadImage() }

    // Then
    try await TestWait.until(object: viewModel, keyPath: \.image, where: { $0 != nil })

    #expect(viewModel.isLoading == false)
    #expect(viewModel.loadFailed == false)
  }

  @Test
  func imageFailsToLoad() async throws {
    // Given
    let mockImageService = MockImageService()
    mockImageService.result = .failure(NetworkError.invalidData)

    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )

    // When
    await MainActor.run { viewModel.loadImage() }

    // Then
    try await TestWait.until(object: viewModel, keyPath: \.isLoading, where: { $0 == false })

    #expect(viewModel.image == nil)
    #expect(viewModel.loadFailed == true)
  }

  @Test
  func retryTriggersLoad() async throws {
    // Given
    let mockImageService = MockImageService()
    mockImageService.result = .success(UIImage())

    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )

    // When
    await MainActor.run { viewModel.retryLoading() }

    // Then
    try await TestWait.until(object: viewModel, keyPath: \.image, where: { $0 != nil })

    #expect(viewModel.loadFailed == false)
  }

  @Test
  func loadImageIsNotTriggeredTwice() async throws {
    // Given
    let mockImageService = MockImageService()
    mockImageService.result = .success(UIImage())
    
    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )

    // When
    await MainActor.run {
      viewModel.loadImage()
      viewModel.loadImage() // Should be ignored
    }

    // Then
    try await TestWait.until(object: viewModel, keyPath: \.image, where: { $0 != nil })

    #expect(viewModel.isLoading == false)
  }

  @Test
  func deinitCancelsTaskAndNotifiesImageService() async throws {
    // Given
    let mockImageService = MockImageService()
    mockImageService.result = .success(UIImage())
    let testURL = "https://image.com/test.png"
    
    var viewModel: CartoonCharacterCellPhotoViewModel? =
    CartoonCharacterCellPhotoViewModel(imageUrl: testURL, imageService: mockImageService)
    
    // When
    if let viewModel {
      await MainActor.run { viewModel.loadImage() }
    }

    try await Task.sleep(nanoseconds: 50_000_000) // start the load
    
    viewModel = nil // trigger deinit
    
    try await Task.sleep(nanoseconds: 50_000_000) // allow cancel to happen

    // Then
    #expect(mockImageService.cancelledURLs.contains(testURL))
    #expect(mockImageService.invocation.contains(where: { $0 == .cancelLoad }))
  }
}
