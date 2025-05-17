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
      Text(
        "\(localizer.localize(key: .status, fallbackValue: .status)): \(character.status.rawValue)"
      )
      .font(.body)
      Divider()
      Text(
        "\(localizer.localize(key: .species, fallbackValue: .species)): \(character.species)"
      )
      .font(.body)
      Divider()
      Text(
        "\(localizer.localize(key: .gender, fallbackValue: .gender)): \(character.gender)"
      )
      .font(.body)
      Divider()
      Text(
        "\(localizer.localize(key: .origin, fallbackValue: .origin)): \(character.origin.name)"
      )
      .font(.body)
      Divider()
      Text(
        "\(localizer.localize(key: .location, fallbackValue: .location)): \(character.location.name)"
      )
      .font(.body)
    }
    .padding()
    .accessibilityElement()
    .accessibilityLabel(character.accessibilityDescription)
  }
}
