//
//  CartoonCharacterCellBuilder.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

struct CartoonCharacterCellBuilder: SceneBuilding {
  private let character: CartoonCharacter
  private let imageService: ImageServiceProtocol
  
  init(character: CartoonCharacter, imageService: ImageServiceProtocol) {
    self.character = character
    self.imageService = imageService
  }
  
  private var viewModel: CartoonCharacterCellViewModel {
    CartoonCharacterCellViewModel(
      character: character,
      imageService: imageService
    )
  }
  
  var view: CartoonCharacterCell {
    CartoonCharacterCell(viewModel: viewModel)
  }
}
