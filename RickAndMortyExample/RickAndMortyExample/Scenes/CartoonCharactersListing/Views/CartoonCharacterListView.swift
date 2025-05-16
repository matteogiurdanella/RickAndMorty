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
              await viewModel.fetchCartoonCharacters()
            }
          }
        } else {
          List(viewModel.filteredCharacters) { character in
            NavigationLink(
              destination: CartoonCharacterDetailBuilder(
                characterId: character.id,
                cartoonCharacterService: .init()
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
          .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
          .refreshable {
            await viewModel.fetchCartoonCharacters()
          }
        }
        
        if viewModel.isLoading {
          LoadingView()
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
