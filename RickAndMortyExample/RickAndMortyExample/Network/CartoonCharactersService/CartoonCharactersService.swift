//
//  CartoonCharactersService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

protocol CartoonCharacterServiceProtocol {
    func fetchCharacters() async throws -> CartoonCharacterListPageModel
    func fetchCharacters(id: Int) async throws -> CartoonCharacter
}

final class CartoonCharacterService: CartoonCharacterServiceProtocol {
  private let networkService: NetworkServiceProtocol
  
  init(
    networkService: NetworkServiceProtocol = NetworkService(
      baseURL: "https://rickandmortyapi.com/api/"
    )
  ) {
    self.networkService = networkService
  }
  
  func fetchCharacters() async throws -> CartoonCharacterListPageModel {
    return try await networkService.fetch(from: "character")
  }
  
  func fetchCharacters(id: Int) async throws -> CartoonCharacter {
    return try await networkService.fetch(from: "character/\(id)")
  }
}
