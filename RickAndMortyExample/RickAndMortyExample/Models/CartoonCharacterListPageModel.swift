//
//  CartoonCharacterListPageModel.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

struct PageModelInfo: Decodable {
  let count: Int
  let pages: Int
  let next: String?
  let prev: String?
}

struct CartoonCharacterListPageModel: Decodable {
  let info: PageModelInfo
  let results: [CartoonCharacter]
}
