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
    Name: \(name). \
    Status: \(status.rawValue). \
    Species: \(species). \
    Gender: \(gender). \
    Origin: \(origin.name). \
    Last known location: \(location.name).
    """
  }
}
