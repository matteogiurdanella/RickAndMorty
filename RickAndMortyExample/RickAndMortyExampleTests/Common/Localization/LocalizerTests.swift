//
//  LocalizerTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

import Testing
@testable import RickAndMortyExample

struct LocalizerTests {
  @Test
  func testTranslationWithStrings() {
    #expect(
      Localizer.shared.localize(key: "Test", fallbackValue: "Test 1") == "Test 1"
    )
  }
  
  func testTranslationWithKeys() {
    #expect(
      Localizer.shared.localize(key: .error, fallbackValue: .tryAgain) == FallbackValue.tryAgain.rawValue
    )
  }
}
