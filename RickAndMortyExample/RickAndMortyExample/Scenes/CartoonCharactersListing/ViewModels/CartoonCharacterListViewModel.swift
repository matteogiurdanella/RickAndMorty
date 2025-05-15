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
  @Published var searchText: String = ""
  
  private let charactersService: CartoonCharacterServiceProtocol
  
  init(charactersService: CartoonCharacterServiceProtocol = CartoonCharacterService()) {
    self.charactersService = charactersService
  }
  
  @MainActor
  func fetchCartoonCharacters() async {
    isLoading = true
    errorMessage = nil
    
    do {
      let pageModel = try await charactersService.fetchCharacters()
      characters = pageModel.results
    } catch let error as NetworkError {
      errorMessage = error.errorDescription
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
  
  var filteredCharacters: [CartoonCharacter] {
    guard !searchText.isEmpty else { return characters }
    
    return characters.filter { character in
      character.name.localizedCaseInsensitiveContains(searchText) ||
      character.status.rawValue.localizedCaseInsensitiveContains(searchText) ||
      character.species.localizedCaseInsensitiveContains(searchText) ||
      character.type.localizedCaseInsensitiveContains(searchText) ||
      character.gender.rawValue.localizedCaseInsensitiveContains(searchText) ||
      character.origin.name.localizedCaseInsensitiveContains(searchText) ||
      character.location.name.localizedCaseInsensitiveContains(searchText)
    }
  }
}

