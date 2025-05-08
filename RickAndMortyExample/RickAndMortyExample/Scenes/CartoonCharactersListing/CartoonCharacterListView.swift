//
//  CartoonCharacterListView.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

struct CartoonCharacterListView: View {
  @ObservedObject private var viewModel: CartoonCharacterListViewModel
  
  init(viewModel: CartoonCharacterListViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        if viewModel.isLoading {
          LoadingView()
        } else if let errorMessage = viewModel.errorMessage {
          ErrorView(errorMessage) {
            Task {
              await viewModel.fetchCartoonCharacters()
            }
          }
        } else {
          List(viewModel.characters) { character in
            NavigationLink(
              destination: CartoonCharacterDetailBuilder(
                characterId: character.id,
                cartoonCharacterService: .init(),
                imageService: ImageService()
              ).view
            ) {
              CartoonCharacterCellBuilder(
                character: character,
                imageService: ImageService()
              ).view
            }
          }
          .listStyle(PlainListStyle())
          .refreshable {
            await viewModel.fetchCartoonCharacters()
          }
        }
      }
      .navigationTitle("Characters")
      .onAppear {
        Task {
          await viewModel.fetchCartoonCharacters()
        }
      }
    }
  }
}
