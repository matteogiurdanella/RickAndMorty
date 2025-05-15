//
//  RickAndMortyExampleApp.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

@main
struct RickAndMortyExampleApp: App {
  var body: some Scene {
    WindowGroup {
      CartoonCharacterListBuilder(
        characterService: .init()
      ).view
    }
  }
}
