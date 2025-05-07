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
          ProgressView()
            .scaleEffect(1.5)
        } else if let errorMessage = viewModel.errorMessage {
          VStack {
            Text("Error")
              .font(.title)
              .foregroundColor(.red)
            Text(errorMessage)
              .foregroundColor(.secondary)
            Button("Try Again") {
              Task {
                await viewModel.fetchPosts()
              }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top)
          }
          .padding()
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
            await viewModel.fetchPosts()
          }
        }
      }
      .navigationTitle("Characters")
      .onAppear {
        Task {
          await viewModel.fetchPosts()
        }
      }
    }
  }
}
