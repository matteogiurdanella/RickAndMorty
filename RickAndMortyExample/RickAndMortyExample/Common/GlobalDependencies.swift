//
//  GlobalDependencies.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

var localizer: Localizing {
  Localizer.shared
}

var imageService: ImageServiceProtocol {
  ImageService.shared
}

var cartoonCharacterService: CartoonCharacterServiceProtocol {
  CartoonCharacterService()
}
