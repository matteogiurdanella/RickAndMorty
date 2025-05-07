//
//  CartoonCharacterListViewModel.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import Combine

final class CartoonCharacterListViewModel: ObservableObject {
  @Published var characters: [CartoonCharacter] = []
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  private let charactersService: CartoonCharacterServiceProtocol
  
  init(charactersService: CartoonCharacterServiceProtocol = CartoonCharacterService()) {
    self.charactersService = charactersService
  }
  
  @MainActor
  func fetchPosts() async {
    isLoading = true
    errorMessage = nil
    
    do {
      let pageModel = try await charactersService.fetchCharacters()
      characters.append(contentsOf: pageModel.results)
    } catch let error as NetworkError {
      errorMessage = error.errorDescription
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
}

