//
//  CartoonCharacterDetailView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

struct CartoonCharacterDetailView: View {
  let characterId: Int
  @ObservedObject private var viewModel: CartoonCharacterDetailViewModel
  
  init(characterId: Int, viewModel: CartoonCharacterDetailViewModel) {
    self.characterId = characterId
    self.viewModel = viewModel
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        if viewModel.isLoading {
          LoadingView()
        } else if let errorMessage = viewModel.errorMessage {
          ErrorView(errorMessage) {
            Task {
              await viewModel.fetchCharacter(id: characterId)
            }
          }
        } else if let character = viewModel.character {
          if let image = viewModel.postImage {
            CartoonDetailImageView(image: image)
          } else if viewModel.isImageLoading {
            PhotoLoadingView()
          }
          CartoonCharacterDetailsInfoView(character: character)
        }
      }
      .padding()
    }
    .onAppear {
      Task {
        await viewModel.fetchCharacter(id: characterId)
      }
    }
  }
}
