//
//  CartoonCharacterInfoCellView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct CartoonCharacterInfoCellView: View {
  private var character: CartoonCharacter

  init(character: CartoonCharacter) {
    self.character = character
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(character.name)
        .font(.headline)
        .lineLimit(1)
      Text(character.species)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .lineLimit(1)
      Text(character.status.rawValue)
        .font(.subheadline)
        .foregroundColor(.secondary.opacity(0.7))
        .lineLimit(1)
    }
  }
}
