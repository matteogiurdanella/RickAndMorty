//
//  CartoonCharacterCellPhotoViewModel.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import UIKit
import SwiftUI

final class CartoonCharacterCellPhotoViewModel: ObservableObject {
  @Published var image: UIImage?
  @Published var isLoading = false
  @Published var loadFailed = false
  
  private(set) var imageUrl: String
  private let imageService: ImageServiceProtocol
  private var loadTask: Task<Void, Never>?
  
  init(
    imageUrl: String,
    imageService: ImageServiceProtocol = ImageService.shared
  ) {
    self.imageUrl = imageUrl
    self.imageService = imageService
  }
  
  @MainActor
  func loadImage() {
    guard image == nil, !isLoading else { return }
    isLoading = true
    loadFailed = false

    // Cancel any existing task
    loadTask?.cancel()
    
    // Create a new task for loading the image
    loadTask = Task { [weak self] in
      guard let self = self else { return }
      
      let result = await imageService.loadImage(from: imageUrl)
      
      if Task.isCancelled { return }
      self.isLoading = false
      switch result {
      case let .success(image):
        self.image = image
      case .failure:
        self.loadFailed = true
      }
    }
  }
  
  @MainActor
  func retryLoading() {
    loadImage()
  }
  
  deinit {
    loadTask?.cancel()
    imageService.cancelLoad(for: imageUrl)
  }
}
