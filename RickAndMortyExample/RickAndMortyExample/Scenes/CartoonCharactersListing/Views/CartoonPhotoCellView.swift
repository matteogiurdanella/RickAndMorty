//
//  CartoonPhotoCellView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 08.05.25.
//

import SwiftUI

struct CartoonPhotoCellView: View {
  @StateObject private var viewModel: CartoonCharacterCellPhotoViewModel

  init(imageUrl: String) {
    _viewModel = StateObject(wrappedValue: CartoonCharacterCellPhotoViewModel(imageUrl: imageUrl))
  }
  
  var body: some View {
    ZStack {
      if viewModel.isLoading {
        PhotoLoadingView()
      } else if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
      } else if viewModel.loadFailed {
        PhotoErrorView {
          viewModel.retryLoading()
        }
      }
    }
    .frame(width: 60, height: 60)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .onAppear() {
      viewModel.loadImage()
    }
  }
}
