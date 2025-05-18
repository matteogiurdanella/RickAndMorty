//
//  MockCartoonCharacter.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

@testable import RickAndMortyExample

extension CartoonCharacter {
  static func mock(
    id: Int,
    name: String? = nil,
    imageUrl: String? = nil
  ) -> Self {
    CartoonCharacter(
      id: id,
      name: name ?? "\(id)",
      status: .alive,
      species: "",
      type: "",
      gender: .male,
      origin: .init(name: "", url: ""),
      location: .init(name: "", url: ""),
      image: imageUrl ?? "",
      episode: [],
      url: "",
      created: ""
    )
  }
}
