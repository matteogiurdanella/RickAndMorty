//
//  CartoonDetailImageView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct CartoonDetailImageView: View {
  private var image: UIImage
  
  init(image: UIImage) {
    self.image = image
  }
  
  var body: some View {
    Image(uiImage: image)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(height: 300)
      .clipped()
      .cornerRadius(8)
      .accessibilityHidden(true)
  }
}
