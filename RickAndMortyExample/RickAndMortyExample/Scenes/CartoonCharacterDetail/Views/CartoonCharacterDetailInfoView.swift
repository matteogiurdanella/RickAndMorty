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
    VStack(alignment: .leading, spacing: 8) {
      Text(character.name)
        .font(.title)
        .fontWeight(.bold)
        .padding(.bottom, 8)
      
      ForEach(Array(detailItems.enumerated()), id: \.element.label) { index, item in
        VStack(alignment: .leading, spacing: 4) {
          Text("\(item.label): \(item.value)")
            .font(.body)
        }
      }
    }
    .padding()
    .accessibilityElement()
    .accessibilityLabel(character.accessibilityDescription)
 
  }
  
  private var detailItems: [(label: String, value: String)] {
    [
      (localizer.localize(key: .status, fallbackValue: .status), character.status.rawValue),
      (localizer.localize(key: .species, fallbackValue: .species), character.species),
      (localizer.localize(key: .gender, fallbackValue: .gender), character.gender.rawValue),
      (localizer.localize(key: .origin, fallbackValue: .origin), character.origin.name),
      (localizer.localize(key: .location, fallbackValue: .location), character.location.name)
    ]
  }
}
