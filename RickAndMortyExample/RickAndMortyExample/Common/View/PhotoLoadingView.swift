//
//  PhotoLoadingView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct PhotoLoadingView: View {
  var body: some View {
    Rectangle()
      .foregroundColor(.gray.opacity(0.2))
      .overlay(
        Image(systemName: "photo.fill")
          .font(.system(size: 30))
          .foregroundColor(.gray)
      )
      .accessibilityHidden(true)
  }
}
