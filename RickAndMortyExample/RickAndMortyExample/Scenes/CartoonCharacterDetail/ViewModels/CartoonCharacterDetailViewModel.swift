//
//  CartoonCharacterDetailViewModel.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import UIKit
import Combine

class CartoonCharacterDetailViewModel: ObservableObject {
  @Published var character: CartoonCharacter?
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  // Image-related properties
  @Published var postImage: UIImage?
  @Published var isImageLoading = false
  
  private let cartoonCharacterService: CartoonCharacterService
  private let imageService: ImageServiceProtocol
  private var loadImageTask: Task<Void, Never>?
  
  init(
    cartoonCharacterService: CartoonCharacterService = .init(),
    imageService: ImageServiceProtocol = ImageService.shared
  ) {
    self.cartoonCharacterService = cartoonCharacterService
    self.imageService = imageService
  }
  
  @MainActor
  func fetchCharacter(id: Int) async {
    isLoading = true
    errorMessage = nil
    
    do {
      character = try await cartoonCharacterService.fetchCharacters(id: id)
      
      // Once we have the post, load its image
      if let character {
        await loadCharacterImage(from: character.image)
      }
    } catch let error as NetworkError {
      errorMessage = error.errorDescription
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
  
  private func loadCharacterImage(from urlString: String) async {
    loadImageTask?.cancel()
    await MainActor.run {
      isImageLoading = true
    }
    
    loadImageTask = Task { [weak self] in
      guard let self = self else { return }
      let image = await imageService.loadImage(from: urlString)
      if Task.isCancelled { return }
      await MainActor.run {
        self.postImage = image
        self.isImageLoading = false
      }
    }
  }
  
  deinit {
    loadImageTask?.cancel()
  }
}
