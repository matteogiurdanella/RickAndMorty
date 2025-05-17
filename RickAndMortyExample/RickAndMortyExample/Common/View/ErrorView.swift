//
//  ErrorView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct ErrorView: View {
  private let message: String
  private let tryAgain: (() -> Void)?
  
  init(_ message: String, tryAgain: (() -> Void)? = nil) {
    self.message = message
    self.tryAgain = tryAgain
  }
  
  var body: some View {
    VStack {
      Text(localizer.localize(key: .error, fallbackValue: .error))
        .font(.title)
        .foregroundColor(.red)
        .accessibilityAddTraits(.isHeader)
      Text(message)
        .foregroundColor(.secondary)
        .accessibilityLabel(localizer.localize(key: .errorMessage, fallbackValue: .errorMessage))
        .accessibilityLabel(message)
      if tryAgain != nil {
        Button(localizer.localize(key: .tryAgain, fallbackValue: .tryAgain)) {
          tryAgain?()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(.top)
        .accessibilityHint(localizer.localize(key: .reload, fallbackValue: .reload))
      }
    }
    .padding()
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(localizer.localize(key: .errorOccured, fallbackValue: .errorOccured)) \(message)")
  }
}
