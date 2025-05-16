//
//  CartoonCharactersService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

protocol CartoonCharacterServiceProtocol {
  func fetchCharacters(page: Int) async throws -> CartoonCharacterListPageModel
  func fetchCharacter(by id: Int) async throws -> CartoonCharacter
}

extension CartoonCharacterServiceProtocol {
  func fetchCharacters(page: Int = 1) async throws -> CartoonCharacterListPageModel {
    try await fetchCharacters(page: page)
  }
}

final class CartoonCharacterService: CartoonCharacterServiceProtocol {
  private let networkService: NetworkServiceProtocol
  
  init(
    networkService: NetworkServiceProtocol = NetworkService(
      baseURL: "https://rickandmortyapi.com/api"
    )
  ) {
    self.networkService = networkService
  }
  
  func fetchCharacters(page: Int = 1) async throws -> CartoonCharacterListPageModel {
    return try await networkService.fetch(from: "character", queryItems: ["page": "\(page)"])
  }
  
  func fetchCharacter(by id: Int) async throws -> CartoonCharacter {
    return try await networkService.fetch(from: "character/\(id)", queryItems: [:])
  }
}
