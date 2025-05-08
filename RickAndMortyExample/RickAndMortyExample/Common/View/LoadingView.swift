//
//  LoadingView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    ProgressView()
      .scaleEffect(1.5)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
  }
}

