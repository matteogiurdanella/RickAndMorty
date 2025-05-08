//
//  PhotoError.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct PhotoError: View {
  var retryLoading: (() -> Void)? = nil
  
  var body: some View {
    Rectangle()
      .foregroundColor(.gray.opacity(0.2))
      .overlay(
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.system(size: 30))
          .foregroundColor(.orange)
      )
      .onTapGesture {
        retryLoading?()
      }
  }
}
