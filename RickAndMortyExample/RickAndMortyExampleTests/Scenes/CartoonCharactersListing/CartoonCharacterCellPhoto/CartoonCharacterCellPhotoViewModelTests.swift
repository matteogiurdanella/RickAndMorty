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
    let mockImageService = MockImageService()
    mockImageService.result = UIImage(systemName: "star")
    
    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )
    
    await MainActor.run { viewModel.loadImage() }

    try await TestWait.until(object: viewModel, keyPath: \.image, where: { $0 != nil })

    #expect(viewModel.isLoading == false)
    #expect(viewModel.loadFailed == false)
  }

  @Test
  func imageFailsToLoad() async throws {
    let mockImageService = MockImageService()
    mockImageService.result = nil

    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )

    await MainActor.run { viewModel.loadImage() }

    try await TestWait.until(object: viewModel, keyPath: \.isLoading, where: { $0 == false })

    #expect(viewModel.image == nil)
    #expect(viewModel.loadFailed == true)
  }

  @Test
  func retryTriggersLoad() async throws {
    let mockImageService = MockImageService()
    mockImageService.result = UIImage(systemName: "star")

    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )

    await MainActor.run { viewModel.retryLoading() }

    try await TestWait.until(object: viewModel, keyPath: \.image, where: { $0 != nil })

    #expect(viewModel.loadFailed == false)
  }

  @Test
  func loadImageIsNotTriggeredTwice() async throws {
    let mockImageService = MockImageService()
    mockImageService.result = UIImage(systemName: "star")

    let viewModel = CartoonCharacterCellPhotoViewModel(
      imageUrl: "https://image.com/pic.png",
      imageService: mockImageService
    )

    await MainActor.run {
      viewModel.loadImage()
      viewModel.loadImage() // Should be ignored
    }

    try await TestWait.until(object: viewModel, keyPath: \.image, where: { $0 != nil })

    #expect(viewModel.isLoading == false)
  }

  @Test
  func deinitCancelsTaskAndNotifiesImageService() async throws {
    let mockImageService = MockImageService()
    mockImageService.result = UIImage(systemName: "star")
    let testURL = "https://image.com/test.png"

    var viewModel: CartoonCharacterCellPhotoViewModel? =
      CartoonCharacterCellPhotoViewModel(imageUrl: testURL, imageService: mockImageService)

    if let viewModel {
      await MainActor.run { viewModel.loadImage() }
    }

    try await Task.sleep(nanoseconds: 50_000_000) // start the load

    viewModel = nil // trigger deinit

    try await Task.sleep(nanoseconds: 50_000_000) // allow cancel to happen

    #expect(mockImageService.cancelledURLs.contains(testURL))
    #expect(mockImageService.invocation == [
      .loadImage,
      .cancelLoad
    ])
  }
}
