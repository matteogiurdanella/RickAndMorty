//
//  CartoonCharacterCellViewModel.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import UIKit
import SwiftUI

final class CartoonCharacterCellViewModel: ObservableObject {
  @Published var image: UIImage?
  @Published var isLoading = false
  @Published var loadFailed = false
  
  private(set) var character: CartoonCharacter
  private let imageService: ImageServiceProtocol
  private var loadTask: Task<Void, Never>?
  
  init(
    character: CartoonCharacter,
    imageService: ImageServiceProtocol = ImageService()
  ) {
    self.character = character
    self.imageService = imageService
  }
  
  @MainActor
  func loadImage() {
    isLoading = true
    loadFailed = false
    
    // Cancel any existing task
    loadTask?.cancel()
    
    // Create a new task for loading the image
    loadTask = Task { [weak self] in
      guard let self = self else { return }
      
      let loadedImage = await imageService.loadImage(from: character.image)
      
      // Check if task was cancelled
      if Task.isCancelled { return }
      
      self.isLoading = false
      if let loadedImage = loadedImage {
        self.image = loadedImage
      } else {
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
    imageService.cancelLoad(for: character.image)
  }
}
