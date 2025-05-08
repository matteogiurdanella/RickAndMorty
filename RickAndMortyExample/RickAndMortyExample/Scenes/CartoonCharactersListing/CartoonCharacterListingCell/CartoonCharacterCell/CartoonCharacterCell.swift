//
//  CartoonCharacterCell.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

struct CartoonCharacterCell: View {
  private let character: CartoonCharacter
  
  init(character: CartoonCharacter) {
    self.character = character
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      CartoonPhotoCellView(imageUrl: character.image)
      CartoonCharacterInfoCellView(character: character)
    }
    .padding(.vertical, 8)
  }
}
