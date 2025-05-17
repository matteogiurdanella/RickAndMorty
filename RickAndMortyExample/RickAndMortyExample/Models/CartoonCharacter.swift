//
//  Characters.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

enum CartoonCharactersStatus: String, Decodable {
  case alive = "Alive"
  case dead = "Dead"
  case unknown = "unknown"
}

enum CartoonCharactersGender: String, Decodable {
  case male = "Male"
  case female = "Female"
  case genderless = "Genderless"
  case unknown = "unknown"
}

struct CartoonCharacterLocation: Decodable {
  let name: String
  let url: String
}

struct CartoonCharacter: Decodable, Identifiable {
  let id: Int
  let name: String
  let status: CartoonCharactersStatus
  let species: String
  let type: String
  let gender: CartoonCharactersGender
  let origin: CartoonCharacterLocation
  let location: CartoonCharacterLocation
  let image: String
  let episode: [String]
  let url: String
  let created: String
  
  var accessibilityDescription: String {
    """
    \(localizer.localize(key: .name, fallbackValue: .name)): \(name). \
    \(localizer.localize(key: .status, fallbackValue: .status)): \(status.rawValue). \
    \(localizer.localize(key: .species, fallbackValue: .species)): \(species). \
    \(localizer.localize(key: .gender, fallbackValue: .gender)): \(gender). \
    \(localizer.localize(key: .origin, fallbackValue: .origin)): \(origin.name). \
    \(localizer.localize(key: .location, fallbackValue: .location)): \(location.name).
    """
  }
}
