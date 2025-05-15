//
//  CartoonCharacter+Preview.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

extension CartoonCharacter {
  static func previewMock(
    id: Int
  ) -> Self {
    CartoonCharacter(
      id: id,
      name: "\(id)",
      status: .alive,
      species: "",
      type: "",
      gender: .male,
      origin: .init(name: "", url: ""),
      location: .init(name: "", url: ""),
      image: "",
      episode: [],
      url: "",
      created: ""
    )
  }
}
