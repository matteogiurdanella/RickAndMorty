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
        if let errorMessage = viewModel.errorMessage {
          ErrorView(errorMessage) {
            Task {
              await viewModel.fetchCartoonCharactersOnRetry()
            }
          }
        } else if viewModel.isLoading {
          LoadingView()
        } else {
          characterListView
        }
      }
      .navigationTitle(localizer.localize(key: .characters, fallbackValue: .characters))
      .task {
        await viewModel.fetchCartoonCharactersOnAppear()
      }
    }
  }
  
  @ViewBuilder
  private var characterListView: some View {
    List(viewModel.filteredCharacters) { character in
      NavigationLink(
        destination: CartoonCharacterDetailBuilder(
          characterId: character.id,
          cartoonCharacterService: cartoonCharacterService,
          imageService: imageService
        ).view
      ) {
        CartoonCharacterCell(character: character)
          .onAppear {
            Task {
              await viewModel.fetchMoreCharactersIfNeeded(character)
            }
          }
      }
    }
    .listStyle(PlainListStyle())
    .searchable(
      text: $viewModel.searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: localizer.localize(key: .search, fallbackValue: .search)
    )
    .refreshable {
      await viewModel.fetchCartoonCharactersOnRefresh()
    }
  }
}
