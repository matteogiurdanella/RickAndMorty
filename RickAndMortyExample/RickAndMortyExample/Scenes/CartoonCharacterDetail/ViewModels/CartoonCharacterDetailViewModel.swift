//
//  CartoonCharacterDetailViewModel.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import UIKit
import Combine

final class CartoonCharacterDetailViewModel: ObservableObject {
  @Published var character: CartoonCharacter?
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var postImage: UIImage?
  @Published var isImageLoading = false
  
  private let cartoonCharacterService: CartoonCharacterServiceProtocol
  private let imageService: ImageServiceProtocol
  private var loadImageTask: Task<Void, Never>?
  
  init(
    cartoonCharacterService: CartoonCharacterServiceProtocol,
    imageService: ImageServiceProtocol
  ) {
    self.cartoonCharacterService = cartoonCharacterService
    self.imageService = imageService
  }
  
  func fetchCharacter(id: Int) async {
    await MainActor.run {
      isLoading = true
      errorMessage = nil
    }
    
    do {
      let result = await cartoonCharacterService.fetchCharacter(by: id)
      switch result {
      case let .success(model):
        await MainActor.run {
          isLoading = false
          character = model
        }
        await loadCharacterImage(from: model.image)
      case let .failure(error):
        await MainActor.run {
          isLoading = false
          errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
      }
    }
  }
  
  private func loadCharacterImage(from urlString: String) async {
    loadImageTask?.cancel()
    await MainActor.run {
      isImageLoading = true
    }
    
    loadImageTask = Task { [weak self] in
      guard let self = self else { return }
      let result = await imageService.loadImage(from: urlString)
      if Task.isCancelled { return }
      await MainActor.run {
        self.isImageLoading = false
        switch result {
        case let .success(image):
          self.postImage = image
        case .failure:
          /**
           This isn't handling the error.
           Improvement here could be to properly handle the error and show a message or a thumbnail
           that would refelect the error and in case trying again to re-download the Image after the Tap.
           */
          self.postImage = nil
        }
      }
    }
  }
  
  deinit {
    loadImageTask?.cancel()
  }
}
