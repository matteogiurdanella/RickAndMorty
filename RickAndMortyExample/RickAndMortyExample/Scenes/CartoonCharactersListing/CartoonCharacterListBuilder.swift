//
//  CartoonCharacterListBuilder.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

struct CartoonCharacterListBuilder: SceneBuilding {
  private let characterService: CartoonCharacterService
  
  init(characterService: CartoonCharacterService) {
    self.characterService = characterService
  }
  
  private var viewModel: CartoonCharacterListViewModel {
    CartoonCharacterListViewModel(
      charactersService: characterService
    )
  }
  
  var view: CartoonCharacterListView {
    CartoonCharacterListView(viewModel: viewModel)
  }
}
