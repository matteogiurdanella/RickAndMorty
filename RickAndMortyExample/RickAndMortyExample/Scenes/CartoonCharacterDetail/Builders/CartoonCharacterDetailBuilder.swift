//
//  CartoonCharacterDetailBuilder.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

final class CartoonCharacterDetailBuilder: SceneBuilding {
  private let characterId: Int
  private let cartoonCharacterService: CartoonCharacterServiceProtocol
  private let imageService: ImageServiceProtocol
  
  private lazy var viewModel = CartoonCharacterDetailViewModel(
    cartoonCharacterService: cartoonCharacterService,
    imageService: imageService
  )
  
  init(
    characterId: Int,
    cartoonCharacterService: CartoonCharacterServiceProtocol,
    imageService: ImageServiceProtocol = ImageService.shared
  ) {
    self.characterId = characterId
    self.cartoonCharacterService = cartoonCharacterService
    self.imageService = imageService
  }
  
  var view: CartoonCharacterDetailView {
    .init(characterId: characterId, viewModel: viewModel)
  }
}
