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
  @Published var errorMessage: String? = nil
  @Published var searchText: String = ""
  
  private var pageModel: CartoonCharacterListPageModel?
  private let charactersService: CartoonCharacterServiceProtocol
  private var currentPage = 1
  var nextPage: Int {
    currentPage = currentPage + 1
    return currentPage
  }
  
  init(charactersService: CartoonCharacterServiceProtocol = CartoonCharacterService()) {
    self.charactersService = charactersService
  }
  
  func fetchCartoonCharacters(page: Int? = nil) async {
    await MainActor.run {
      isLoading = true
      self.errorMessage = nil
    }
    
    let result = await fetchCartoonCharacters(page: page ?? currentPage)
    switch result {
    case let .success(pageModel):
      self.pageModel = pageModel
      await MainActor.run {
        characters.append(contentsOf: pageModel.results)
      }
    case let .failure(error):
      await MainActor.run {
        if let error = error as? NetworkError {
          errorMessage = error.errorDescription
        } else {
          errorMessage = error.localizedDescription
        }
      }
    }
    
    await MainActor.run {
      isLoading = false
    }
  }
  
  func fetchMoreCharactersIfNeeded(_ character: CartoonCharacter) async {
    if let index = characters.firstIndex(where: { $0.id == character.id }) {
      if index == characters.count - 5 {
        await fetchCartoonCharacters(page: nextPage)
      }
    }
  }
  
  private func fetchCartoonCharacters(page: Int = 1) async -> Result<CartoonCharacterListPageModel, Error>{
    do {
      let pageModel = try await charactersService.fetchCharacters(page: page)
      return .success(pageModel)
    } catch let error {
      return .failure(error)
    }
  }
  
  var filteredCharacters: [CartoonCharacter] {
    guard !searchText.isEmpty else { return characters }
    
    return characters.filter { character in
      character.name.localizedCaseInsensitiveContains(searchText) ||
      character.status.rawValue.localizedCaseInsensitiveContains(searchText) ||
      character.species.localizedCaseInsensitiveContains(searchText)
    }
  }
}

