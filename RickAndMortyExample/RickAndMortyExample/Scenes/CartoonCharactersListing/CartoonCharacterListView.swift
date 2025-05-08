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
          List(viewModel.filteredCharacters) { character in
            NavigationLink(
              destination: CartoonCharacterDetailBuilder(
                characterId: character.id,
                cartoonCharacterService: .init()
              ).view
            ) {
              CartoonCharacterCell(character: character)
            }
          }
          .listStyle(PlainListStyle())
          .searchable(text: $viewModel.searchText, prompt: "Search")
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

#Preview {
  let mockCharacters: [CartoonCharacter] = [
    CartoonCharacter.previewMock(id: 1),
    CartoonCharacter.previewMock(id: 2)
  ]
  
  let mockViewModel = CartoonCharacterListViewModel(
    charactersService: MockCartoonCharacterService(characters: mockCharacters)
  )
  mockViewModel.characters = mockCharacters
  mockViewModel.isLoading = false
  
  return CartoonCharacterListView(viewModel: mockViewModel)
}

class MockCartoonCharacterService: CartoonCharacterServiceProtocol {
  private let mockCharacters: [CartoonCharacter]

  init(characters: [CartoonCharacter]) {
    self.mockCharacters = characters
  }
  
  func fetchCharacters(id: Int) async throws -> CartoonCharacter {
    mockCharacters.filter { $0.id == id }.first!
  }

  func fetchCharacters() async throws -> CartoonCharacterListPageModel {
    .init(
      info: .init(count: 0, pages: 0, next: nil, prev: nil),
      results: mockCharacters
    )
  }
}
