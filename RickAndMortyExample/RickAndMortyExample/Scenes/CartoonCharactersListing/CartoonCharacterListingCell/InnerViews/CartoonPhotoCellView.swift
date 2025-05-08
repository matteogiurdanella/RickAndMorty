//
//  CartoonPhotoCellView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct CartoonPhotoCellView: View {
  @ObservedObject private var viewModel: CartoonCharacterCellViewModel

  init(viewModel: CartoonCharacterCellViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      if viewModel.isLoading {
        PhotoLoading()
      } else if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
      } else if viewModel.loadFailed {
        PhotoError {
          viewModel.retryLoading()
        }
      }
    }
    .frame(width: 60, height: 60)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}
