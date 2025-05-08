//
//  CartoonCharacterDetailInfoView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct CartoonCharacterDetailsInfoView: View {
  private let character: CartoonCharacter
  
  init(character: CartoonCharacter) {
    self.character = character
  }
  
  var body: some View {
    Text(character.name)
      .font(.title)
      .fontWeight(.bold)
      .padding(.bottom, 8)
    Text("Status: \(character.status.rawValue)")
      .font(.body)
    Divider()
    Text("Species: \(character.species)")
      .font(.body)
    Divider()
    Text("Gender: \(character.gender)")
      .font(.body)
    Divider()
    Text("Origin: \(character.origin.name)")
      .font(.body)
    Divider()
    Text("Last known locaion: \(character.location.name)")
      .font(.body)
  }
}
