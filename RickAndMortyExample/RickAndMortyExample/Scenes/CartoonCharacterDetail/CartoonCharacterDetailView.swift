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
          ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        } else if let errorMessage = viewModel.errorMessage {
          VStack {
            Text("Error")
              .font(.title)
              .foregroundColor(.red)
            Text(errorMessage)
              .foregroundColor(.secondary)
            Button("Try Again") {
              Task {
                await viewModel.fetchCharacter(id: characterId)
              }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top)
          }
          .padding()
        } else if let character = viewModel.character {
          if let image = viewModel.postImage {
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(height: 200)
              .frame(maxWidth: .infinity)
              .clipped()
              .cornerRadius(8)
          } else if viewModel.isImageLoading {
            Rectangle()
              .foregroundColor(.gray.opacity(0.2))
              .frame(height: 200)
              .frame(maxWidth: .infinity)
              .cornerRadius(8)
              .overlay(
                ProgressView()
                  .scaleEffect(1.5)
              )
          }
          Text(character.name)
            .font(.title)
            .fontWeight(.bold)
            .padding(.bottom, 8)
          
          Text("User ID: \(character.id)")
            .font(.subheadline)
            .foregroundColor(.secondary)
          
          Divider()
            .padding(.vertical, 8)
          
          Text(character.species)
            .font(.body)
        }
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .navigationTitle("Character Details")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      Task {
        await viewModel.fetchCharacter(id: characterId)
      }
    }
  }
}
