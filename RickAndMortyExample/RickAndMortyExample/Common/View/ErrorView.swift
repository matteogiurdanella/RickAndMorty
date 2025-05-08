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
      Text("Error")
        .font(.title)
        .foregroundColor(.red)
      Text(message)
        .foregroundColor(.secondary)
      if tryAgain != nil {
        Button("Try Again") {
          tryAgain?()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(.top)
      }
    }
    .padding()
  }
}
