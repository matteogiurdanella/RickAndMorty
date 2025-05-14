//
//  MockCartoonCharacterService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

@testable import RickAndMortyExample

extension CartoonCharacterService {
  static func mock() -> CartoonCharacterService {
    CartoonCharacterService(
      networkService: MockNetworkService()
    )
  }
}
