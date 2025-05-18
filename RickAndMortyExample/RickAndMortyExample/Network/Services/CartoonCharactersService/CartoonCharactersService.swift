//
//  CartoonCharactersService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

protocol CartoonCharacterServiceProtocol {
  func fetchCharacters(page: Int) async -> Result<CartoonCharacterListPageModel, Error>
  func fetchCharacter(by id: Int) async -> Result<CartoonCharacter, Error>
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
  
  func fetchCharacters(page: Int) async -> Result<CartoonCharacterListPageModel, Error> {
    return await networkService.fetch(from: "character", queryItems: ["page": "\(page)"])
  }
  
  func fetchCharacter(by id: Int) async -> Result<CartoonCharacter, Error> {
    return await networkService.fetch(from: "character/\(id)", queryItems: [:])
  }
}
