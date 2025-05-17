//
//  CartoonCharacterDetailBuilder.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

struct CartoonCharacterDetailBuilder: SceneBuilding {
  private let characterId: Int
  private let cartoonCharacterService: CartoonCharacterService
  private let imageService: ImageService
  
  init(
    characterId: Int,
    cartoonCharacterService: CartoonCharacterService,
    imageService: ImageService = ImageService.shared
  ) {
    self.characterId = characterId
    self.cartoonCharacterService = cartoonCharacterService
    self.imageService = imageService
  }
  
  private var viewModel: CartoonCharacterDetailViewModel {
    CartoonCharacterDetailViewModel(
      cartoonCharacterService: cartoonCharacterService,
      imageService: imageService
    )
  }
  
  var view: CartoonCharacterDetailView {
    print("MG: \(characterId)")
    return .init(characterId: characterId, viewModel: viewModel)
  }
}
