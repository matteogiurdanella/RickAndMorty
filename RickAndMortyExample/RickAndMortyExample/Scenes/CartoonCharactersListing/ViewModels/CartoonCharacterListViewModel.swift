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
  private var isFirstLoad: Bool = true
  
  init(charactersService: CartoonCharacterServiceProtocol = CartoonCharacterService()) {
    self.charactersService = charactersService
  }
  
  func fetchCartoonCharactersOnAppear() async {
    guard isFirstLoad else { return }
    isFirstLoad = false
    await fetchCartoonCharacters(page: currentPage)
  }
  
  func fetchMoreCharactersIfNeeded(_ character: CartoonCharacter) async {
    if
      let index = characters.firstIndex(where: { $0.id == character.id }),
      index == characters.count - 5 {
        currentPage += 1
        await fetchCartoonCharacters(page: currentPage)
    }
  }
  
  func fetchCartoonCharactersOnRetry() async {
    await fetchCartoonCharactersOnRefresh()
  }
  
  func fetchCartoonCharactersOnRefresh() async {
    await MainActor.run {
      characters = []
    }
    pageModel = nil
    currentPage = 1
    await fetchCartoonCharacters(page: currentPage)
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

private extension CartoonCharacterListViewModel {
  func fetchCartoonCharacters(page: Int? = nil) async {
    await MainActor.run {
      isLoading = true
      self.errorMessage = nil
    }
    
    let result = await charactersService.fetchCharacters(page: page ?? currentPage)
    switch result {
    case let .success(pageModel):
      self.pageModel = pageModel
      await MainActor.run {
        characters.append(contentsOf: pageModel.results)
      }
    case let .failure(error):
      await MainActor.run {
        errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
      }
    }
    
    await MainActor.run {
      isLoading = false
    }
  }
}
