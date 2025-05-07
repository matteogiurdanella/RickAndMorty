//
//  CartoonCharacterCell.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

struct CartoonCharacterCell: View {
  let character: CartoonCharacter
  @ObservedObject private var viewModel: CartoonCharacterCellViewModel
  
  init(character: CartoonCharacter, viewModel: CartoonCharacterCellViewModel) {
    self.character = character // TODO: Do I need character here?
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      ZStack {
        if viewModel.isLoading {
          // Loading state
          Rectangle()
            .foregroundColor(.gray.opacity(0.2))
            .overlay(
              Image(systemName: "photo.fill")
                .font(.system(size: 30))
                .foregroundColor(.gray)
            )
        } else if let image = viewModel.image {
          // Success state
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
        } else if viewModel.loadFailed {
          // Error state
          Rectangle()
            .foregroundColor(.gray.opacity(0.2))
            .overlay(
              Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundColor(.orange)
            )
            .onTapGesture {
              viewModel.retryLoading()
            }
        }
      }
      .frame(width: 60, height: 60)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      
      VStack(alignment: .leading, spacing: 8) {
        Text(viewModel.character.name)
          .font(.headline)
          .lineLimit(1)
        Text(viewModel.character.species)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .lineLimit(2)
      }
    }
    .padding(.vertical, 8)
    .onAppear() {
      viewModel.loadImage()
    }
  }
}
