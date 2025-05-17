//
//  Localizing.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

/**
 This class is just a mock class for the Translations.
 This is extracting the dependency of Localization and this would be the place where to add it.
 Wether in future it is decided to just go for the NSLocalization or with TranslationProvider doing the change here will reflect it in the entire app.
 */
protocol Localizing {
  func localize(key: String, fallbackValue: String) -> String
}

extension Localizing {
  func localize(key: TranslationKey, fallbackValue: FallbackValue) -> String {
    return localize(key: key.rawValue, fallbackValue: fallbackValue.rawValue)
  }
}

class Localizer: Localizing {
  static let shared: Localizing = Localizer()
  
  private init() {}
  
  func localize(key: String, fallbackValue: String) -> String {
    return fallbackValue
  }
}
